SET SERVEROUTPUT ON;

-----------------------------------------------------------
-- TP2 : 	Les	structures	de	contr�les	en	Pl/Sql
-----------------------------------------------------------

----------------------------
-- Question 1 TP2 : 
----------------------------

----------------------------
-- Question 2 : 
-- Tableaux associatifs et enregistrements personnalis�s
----------------------------
DECLARE 
    -- 2.a : D�claration d'un type record pour la structure a�roport
    TYPE struct_aeroport IS RECORD (
        v_code_aeroport VARCHAR2(3 BYTE),
        v_nom_aeroport VARCHAR2(100 BYTE), 
        v_ville VARCHAR2(50 BYTE), 
        v_pays VARCHAR2(30 BYTE), 
        v_nombre_pistes NUMBER(2,0)
    );

    -- D�claration d'un type table associatif bas� sur le record
    TYPE tab_aeroports IS TABLE OF struct_aeroport;
    
    -- Variable de type tableau d'a�roports
    v_aeroport tab_aeroports := tab_aeroports();
    
    -- Variable pour stocker le nombre total d'a�roports
    nb_total NUMBER;
    i integer :=1;

BEGIN
    -- 2.b : Extension du tableau pour 3 �l�ments et insertion des donn�es
    v_aeroport.EXTEND(3);
    
    -- Insertion du premier a�roport
    v_aeroport(1).v_code_aeroport := 'CMN';
    v_aeroport(1).v_nom_aeroport  := 'Mohammed V';
    v_aeroport(1).v_ville         := 'Casablanca';
    v_aeroport(1).v_pays          := 'Maroc';
    v_aeroport(1).v_nombre_pistes := 3;

    -- Insertion du deuxi�me a�roport
    v_aeroport(2).v_code_aeroport := 'RAK';
    v_aeroport(2).v_nom_aeroport  := 'Marrakech Menara';
    v_aeroport(2).v_ville         := 'Marrakech';
    v_aeroport(2).v_pays          := 'Maroc';
    v_aeroport(2).v_nombre_pistes := 2;

    -- Insertion du troisi�me a�roport
    v_aeroport(3).v_code_aeroport := 'TNG';
    v_aeroport(3).v_nom_aeroport  := 'Ibn Battouta';
    v_aeroport(3).v_ville         := 'Tanger';
    v_aeroport(3).v_pays          := 'Maroc';
    v_aeroport(3).v_nombre_pistes := 1;

    -- Affichage des trois a�roports (avec boucle)
    loop
    DBMS_OUTPUT.PUT_LINE('A�roports '|| i || ' : ( ' || v_aeroport(i).v_code_aeroport || ' , ' || v_aeroport(i).v_nom_aeroport || ' , ' || v_aeroport(i).v_ville || ' , ' || v_aeroport(i).v_pays || ' , ' ||v_aeroport(i).v_nombre_pistes || ' ) ' );
    i:=i+1;
    exit when i> v_aeroport.count;
    end loop;
    -- 2.c : Compter le nombre total d'a�roports dans le tableau
    nb_total := v_aeroport.COUNT;
    DBMS_OUTPUT.PUT_LINE('Nombre total d''a�roports : ' || nb_total);
END;
/

----------------------------
-- Question 3 : 
-- Tableaux bas�s sur la structure de table existante (%ROWTYPE)
----------------------------
declare

type tab_aeroport is table of aeroport%rowtype;
v_aeroport tab_aeroport:=tab_aeroport();

nb_total NUMBER;

begin
v_aeroport.extend(3);
v_aeroport(1).code_aeroport:=1;
v_aeroport(1).nom_aeroport:='CDG';
v_aeroport(1).ville:='Paris';
v_aeroport(1).pays :='France';
v_aeroport(1).nombre_pistes:=2;

v_aeroport(2).code_aeroport:=2;
v_aeroport(2).nom_aeroport:='ABS';
v_aeroport(2).ville:='Rabat';
v_aeroport(2).pays :='Maroc';
v_aeroport(2).nombre_pistes:=9;

v_aeroport(3).code_aeroport:=3;
v_aeroport(3).nom_aeroport:='BNC';
v_aeroport(3).ville:='Barcelone';
v_aeroport(3).pays :='Spain';
v_aeroport(3).nombre_pistes:=6;

for i in 1..v_aeroport.count loop
DBMS_OUTPUT.PUT_LINE('A�roport ' ||' ' || i || ' : ( ' || v_aeroport(i).code_aeroport || ' , ' || v_aeroport(i).nom_aeroport || ' , ' || v_aeroport(i).ville || ' , ' || v_aeroport(i).pays || ' , ' ||v_aeroport(i).nombre_pistes || ' ) ' );
end loop;
nb_total := v_aeroport.COUNT;
DBMS_OUTPUT.PUT_LINE('Nombre total d''a�roports : ' || nb_total);

end;
/


----------------------------
-- Question 2 TP2 : 
-- 2.a 
----------------------------

begin
    update pilote
    set salaire = salaire *
        case 
            when age < 30 then 1.05
            when age between 30 and 50 then 1.10
            when age > 50 then 1.15
        end;
end;
/

----------------------------
-- Question 2 TP2 : 
-- 2.b 
----------------------------
begin
    for rec in (
        select nom,
               age,
               salaire as salaire_actuel,
               case
                   when age < 30 then salaire * 0.05
                   when age between 30 and 50 then salaire * 0.10
                   when age > 50 then salaire * 0.15
               end as bonus,
               case
                   when age < 30 then salaire * 1.05
                   when age between 30 and 50 then salaire * 1.10
                   when age > 50 then salaire * 1.15
               end as nouveau_salaire
        from pilote
    )
    loop
        dbms_output.put_line('nom : ' || rec.nom ||
                             ' | age : ' || rec.age ||
                             ' | salaire actuel : ' || rec.salaire_actuel ||
                             ' | bonus : ' || rec.bonus ||
                             ' | nouveau salaire : ' || rec.nouveau_salaire);
    end loop;
end;
/

----------------------------
-- Question 3 TP2 : 
-- 3.a
----------------------------
declare
    type tab_nom is table of pilote.nom%type;
    type tab_salaire is table of pilote.salaire%type;

    v_noms     tab_nom;
    v_salaires tab_salaire;
begin
    select nom, salaire
    bulk collect into v_noms, v_salaires
    from pilote;

    for i in 1 .. v_noms.count loop
        dbms_output.put_line('Nom : ' || v_noms(i) ||
                             ' | Salaire : ' || v_salaires(i));
    end loop;
end;
/

----------------------------
-- Question 3 TP2 : 
-- 3.b
----------------------------
declare
    type tab_nom is table of pilote.nom%type;
    type tab_heures is table of pilote.heure_vols%type;

    v_noms   tab_nom;
    v_heures tab_heures;
begin
    select nom, heure_vols bulk collect into v_noms, v_heures from pilote;

    for i in 1 .. v_noms.count loop
        dbms_output.put_line('Nom : ' || v_noms(i) || ' | Heures de vol : ' || v_heures(i) || ' | Classe : ' ||
        case
        when v_heures(i) < 30000 then 'D�butant'
        when v_heures(i) between 30000 and 70000 then 'Exp�riment�'
        else 'Expert'
        end);
    end loop;
end;
/

----------------------------
-- Question 4 TP2 : 
-- 4.a
----------------------------
-- Question 4
declare
    v_passager   number := &N_passager;
    v_date_res   date   := &Date_reservation;
    v_vol        varchar2(8) := '&N_vol';

    v_date_depart   date;
    v_statut_vol    varchar2(20);
    v_deja_reserve  number;
begin
    -- R�cup�rer infos du vol
    select date_depart, statut_vol
    into v_date_depart, v_statut_vol
    from vol
    where id_vol = v_vol;

    -- V�rifier si le passager a d�j� r�serv� ce vol
    select count(*)
    into v_deja_reserve
    from reservation
    where n_passager = v_passager
      and n_vol = v_vol;

    -- V�rification 1 : date pass�e
    if v_date_res < sysdate then
        dbms_output.put_line('? ERREUR : La date de r�servation est dans le pass�');

    -- V�rification 2 : moins de 2 jours avant d�part
    elsif v_date_res > v_date_depart - 2 then
        dbms_output.put_line('? ERREUR : R�servation doit �tre faite au moins 2 jours avant le d�part');

    -- V�rification 3 : vol annul�
    elsif v_statut_vol = 'Annul�' then
        dbms_output.put_line('? ERREUR : Le vol est annul�');

    -- V�rification 4 : d�j� r�serv�
    elsif v_deja_reserve > 0 then
        dbms_output.put_line('? ERREUR : Le passager a d�j� r�serv� ce vol');

    else
        -- Insertion avec s�quence
        insert into reservation(n_reservation, n_vol, n_passager, date_res)
        values (seq_reservation.nextval, v_vol, v_passager, v_date_res);

        commit;
        dbms_output.put_line('? R�servation effectu�e avec succ�s');
    end if;
end;
/
