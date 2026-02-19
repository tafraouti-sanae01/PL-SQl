set serveroutput on;
-- Question 1(a-b-c)
declare
cursor cur_pilotes is select * from pilote order by heure_vols desc;
v_pilote pilote%ROWTYPE;

begin
open cur_pilotes;
if cur_pilotes%ISOPEN then
fetch cur_pilotes into v_pilote;   
if cur_pilotes%FOUND then 
DBMS_OUTPUT.PUT_LINE('Pilote avec le PLUS d''heures de vol : ' ||v_pilote.nom || ' ' || v_pilote.prenom ||' (' || v_pilote.heure_vols || ' heures)');
end if;
end if;
DBMS_OUTPUT.PUT_LINE('Rang ' || cur_pilotes%ROWCOUNT || ' - ' || v_pilote.nom || ' ' || v_pilote.prenom ||' - Heures de vol : ' || v_pilote.heure_vols);
loop 
fetch cur_pilotes into v_pilote;
exit when cur_pilotes%notfound;
DBMS_OUTPUT.PUT_LINE('Rang ' || cur_pilotes%ROWCOUNT ||' - ' || v_pilote.nom || ' ' || v_pilote.prenom ||' - Heures de vol : ' || v_pilote.heure_vols);
end loop;
close cur_pilotes;
end;
/
-- Question 2(a)
declare
cursor cur_vols (p_ville varchar2 := 'CASABLANCA') is select v.*
from vol v join aeroport a on v.aeroport_depart = a.code_aeroport where upper(a.ville) = upper(p_ville);

v_vol vol%ROWTYPE;
begin
dbms_output.put_line('Vols au depart de ' || 'CASABLANCA :');

open cur_vols;  
loop
fetch cur_vols into v_vol;
exit when cur_vols%NOTFOUND;

dbms_output.put_line('Vol : ' || v_vol.id_vol ||' | Depart : ' || v_vol.date_depart ||' | Arrivee : ' || v_vol.date_arrivee ||' | Aeroport depart : ' || v_vol.aeroport_depart ||
    ' | Aeroport arrivee : ' || v_vol.aeroport_arrivee ||' | Avion : ' || v_vol.n_avion ||' | Pilote : ' || v_vol.n_pilote ||' | Compagnie : ' || v_vol.id_compagnie ||
    ' | Prix : ' || v_vol.prix_base ||' | Statut : ' || v_vol.statut_vol);
end loop;

close cur_vols;
end;
/


-- Question 2(b)
declare
cursor cur_vols (p_ville varchar2 := 'CASABLANCA') is
select v.* from vol v join aeroport a on v.aeroport_depart = a.code_aeroport where upper(a.ville) = upper(p_ville);

v_vol vol%ROWTYPE;
begin
-- Test 1 : CASABLANCA
dbms_output.put_line('=== VOLS AU DEPART DE CASABLANCA ===');

open cur_vols('CASABLANCA');
loop
fetch cur_vols into v_vol;
exit when cur_vols%NOTFOUND;

dbms_output.put_line('Vol : ' || v_vol.id_vol ||' | Depart : ' || v_vol.date_depart ||' | Arrivee : ' || v_vol.date_arrivee ||' | Aeroport dep : ' || v_vol.aeroport_depart ||
' | Aeroport arr : ' || v_vol.aeroport_arrivee ||' | Avion : ' || v_vol.n_avion ||' | Pilote : ' || v_vol.n_pilote ||' | Compagnie : ' || v_vol.id_compagnie ||
' | Prix : ' || v_vol.prix_base ||' | Statut : ' || v_vol.statut_vol);
end loop;
close cur_vols;

-- Test 2 : RABAT
dbms_output.put_line('=== VOLS AU DEPART DE RABAT ===');

open cur_vols('RABAT');
loop
fetch cur_vols into v_vol;
exit when cur_vols%NOTFOUND;

dbms_output.put_line('Vol : ' || v_vol.id_vol ||' | Depart : ' || v_vol.date_depart ||' | Arrivee : ' || v_vol.date_arrivee ||
' | Aeroport dep : ' || v_vol.aeroport_depart ||' | Aeroport arr : ' || v_vol.aeroport_arrivee ||' | Avion : ' || v_vol.n_avion ||
' | Pilote : ' || v_vol.n_pilote ||' | Compagnie : ' || v_vol.id_compagnie ||' | Prix : ' || v_vol.prix_base ||' | Statut : ' || v_vol.statut_vol);
end loop;
close cur_vols;

-- Test 3 : TANGER
dbms_output.put_line('=== VOLS AU DEPART DE TANGER ===');

open cur_vols('TANGER');
loop
fetch cur_vols into v_vol;
exit when cur_vols%NOTFOUND;

dbms_output.put_line('Vol : ' || v_vol.id_vol ||' | Depart : ' || v_vol.date_depart ||' | Arrivee : ' || v_vol.date_arrivee ||' | Aeroport dep : ' || v_vol.aeroport_depart ||
' | Aeroport arr : ' || v_vol.aeroport_arrivee ||' | Avion : ' || v_vol.n_avion ||' | Pilote : ' || v_vol.n_pilote ||
' | Compagnie : ' || v_vol.id_compagnie ||' | Prix : ' || v_vol.prix_base ||' | Statut : ' || v_vol.statut_vol);
end loop;
close cur_vols;

end;
/


-- Question 3
declare
cursor cur_pilotes is select * from pilote for update;

v_pil pilote%ROWTYPE;
v_total_heures number;
begin
open cur_pilotes;

loop
fetch cur_pilotes into v_pil;
exit when cur_pilotes%NOTFOUND;

select nvl(sum( (date_arrivee - date_depart) * 24 ), 0)into v_total_heures from vol where n_pilote = v_pil.id_pil;

update pilote set heure_vols = v_total_heures where current of cur_pilotes;

dbms_output.put_line('Pilote : ' || v_pil.nom ||' | Anciennes heures : ' || nvl(v_pil.heure_vols,0) ||' | Nouvelles heures : ' || v_total_heures);
end loop;

close cur_pilotes;

commit;
dbms_output.put_line('Mise a jour terminee avec succes.');
end;
/

