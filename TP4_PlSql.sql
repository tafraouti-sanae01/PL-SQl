SET SERVEROUTPUT ON;

-----------------------------------------------------------
-- TP4 : 	Les	programmes	stockés	et	les	déclencheurs	en	Pl/Sql
-----------------------------------------------------------
-- Question 1: (a,b,c)

create or replace procedure add_reservation( p_id_passager number, p_id_vol varchar2, p_id_classe number )
is
v_date_reservation date := sysdate;
v_count number;
begin
select count(*) into v_count from passager where id_pas = p_id_passager;

if v_count = 0 then
raise_application_error(-20001, 'Passager introuvable.');
end if;
    
select count(*) into v_count from vol where id_vol = p_id_vol;

if v_count = 0 then
raise_application_error(-20002, 'Vol introuvable.');
end if;
    
if v_date_reservation < trunc(sysdate) then
raise_application_error(-20003, 'Date de reservation invalide.');
end if;
    
insert into reservation( n_reservation, n_vol, n_passager, id_classe, date_res, statut_reservation)
values( seq_reservation.nextval, p_id_vol, p_id_passager, p_id_classe, v_date_reservation, 'En attente');

commit;
dbms_output.put_line('Reservation ajoutee avec succes.');
exception
when others then
dbms_output.put_line('Erreur : ' || sqlerrm);
end;
/

-- Question 2: 

create or replace procedure prime( p_id_pilote in number, p_taux in out number)
is
v_salaire pilote.salaire%type;
begin
if p_taux > 40 then
raise_application_error(-20001, 'Le taux ne depasser pas 40%.');
end if;

select salaire into v_salaire from pilote where id_pil = p_id_pilote;

v_salaire := v_salaire + (v_salaire * (p_taux / 100));

update pilote set salaire = v_salaire where id_pil = p_id_pilote;

p_taux := v_salaire;

dbms_output.put_line('Salaire mis a jour avec succes.');
exception
when no_data_found then
dbms_output.put_line('Pilote introuvable.');
when others then
dbms_output.put_line('Erreur : ' || sqlerrm);
end;
/

-- Test 
SET SERVEROUTPUT ON;

declare
    v_taux number := 30;
begin
    prime(3, v_taux);

    dbms_output.put_line('Nouveau salaire = ' || v_taux);
end;
/


-- Question 3:
create table archivs_vol (utilisateur varchar2(30), date_action date, id_pilote number,date_depart date);

create or replace trigger t_limite_aff before insert on vol;




