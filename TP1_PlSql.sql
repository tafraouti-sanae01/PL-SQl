SET SERVEROUTPUT ON;

-----------------------------------------------------------
-- TP1 : Les variables en PL/SQL
-----------------------------------------------------------

----------------------------
-- Question 2 : 
-- Tableaux associatifs et enregistrements personnalis?s
----------------------------
DECLARE 
    -- 2.a : D?claration d'un type record pour la structure a?roport
    TYPE struct_aeroport IS RECORD (
        v_code_aeroport VARCHAR2(3 BYTE),
        v_nom_aeroport VARCHAR2(100 BYTE), 
        v_ville VARCHAR2(50 BYTE), 
        v_pays VARCHAR2(30 BYTE), 
        v_nombre_pistes NUMBER(2,0)
    );

    -- D?claration d'un type table associatif bas? sur le record
    TYPE tab_aeroports IS TABLE OF struct_aeroport;
    
    -- Variable de type tableau d'a?roports
    v_aeroport tab_aeroports := tab_aeroports();
    
    -- Variable pour stocker le nombre total d'a?roports
    nb_total NUMBER;

BEGIN
    -- 2.b : Extension du tableau pour 3 ?l?ments et insertion des donn?es
    v_aeroport.EXTEND(3);
    
    -- Insertion du premier a?roport
    v_aeroport(1).v_code_aeroport := 'CMN';
    v_aeroport(1).v_nom_aeroport  := 'Mohammed V';
    v_aeroport(1).v_ville         := 'Casablanca';
    v_aeroport(1).v_pays          := 'Maroc';
    v_aeroport(1).v_nombre_pistes := 3;

    -- Insertion du deuxi?me a?roport
    v_aeroport(2).v_code_aeroport := 'RAK';
    v_aeroport(2).v_nom_aeroport  := 'Marrakech Menara';
    v_aeroport(2).v_ville         := 'Marrakech';
    v_aeroport(2).v_pays          := 'Maroc';
    v_aeroport(2).v_nombre_pistes := 2;

    -- Insertion du troisi?me a?roport
    v_aeroport(3).v_code_aeroport := 'TNG';
    v_aeroport(3).v_nom_aeroport  := 'Ibn Battouta';
    v_aeroport(3).v_ville         := 'Tanger';
    v_aeroport(3).v_pays          := 'Maroc';
    v_aeroport(3).v_nombre_pistes := 1;

    -- Affichage des trois a?roports (sans boucle)
    DBMS_OUTPUT.PUT_LINE('A?roports 1 : ( ' || v_aeroport(1).v_code_aeroport || ' , ' || v_aeroport(1).v_nom_aeroport || ' , ' || v_aeroport(1).v_ville || ' , ' || v_aeroport(1).v_pays || ' , ' ||v_aeroport(1).v_nombre_pistes || ' ) ' );
    DBMS_OUTPUT.PUT_LINE('A?roports 2 : ( ' || v_aeroport(2).v_code_aeroport || ' , ' || v_aeroport(2).v_nom_aeroport || ' , ' || v_aeroport(2).v_ville || ' , ' || v_aeroport(2).v_pays || ' , ' ||v_aeroport(2).v_nombre_pistes || ' ) ' );
    DBMS_OUTPUT.PUT_LINE('A?roports 3 : ( ' || v_aeroport(3).v_code_aeroport || ' , ' || v_aeroport(3).v_nom_aeroport || ' , ' || v_aeroport(3).v_ville || ' , ' || v_aeroport(3).v_pays || ' , ' ||v_aeroport(3).v_nombre_pistes || ' ) ' );

    -- 2.c : Compter le nombre total d'a?roports dans le tableau
    nb_total := v_aeroport.COUNT;
    DBMS_OUTPUT.PUT_LINE('Nombre total d''a?roports : ' || nb_total);
END;
/

----------------------------
-- Question 3 : 
-- Tableaux bas?s sur la structure de table existante (%ROWTYPE)
----------------------------
DECLARE
    -- D?claration d'un type table bas? sur la structure de la table AEROPORT
    TYPE tab_aeroports IS TABLE OF aeroport%ROWTYPE;
    
    -- Variable de type tableau d'a?roports
    v_aeroport tab_aeroports := tab_aeroports();
    
    -- Variable pour stocker le nombre total d'a?roports
    nb_total NUMBER;

BEGIN
    -- Extension du tableau pour 3 ?l?ments et insertion des donn?es
    v_aeroport.EXTEND(3);
    
    -- Insertion du premier a?roport
    v_aeroport(1).code_aeroport := 'CMN';
    v_aeroport(1).nom_aeroport  := 'Mohammed V';
    v_aeroport(1).ville         := 'Casablanca';
    v_aeroport(1).pays          := 'Maroc';
    v_aeroport(1).nombre_pistes := 3;

    -- Insertion du deuxi?me a?roport
    v_aeroport(2).code_aeroport := 'RAK';
    v_aeroport(2).nom_aeroport  := 'Marrakech Menara';
    v_aeroport(2).ville         := 'Marrakech';
    v_aeroport(2).pays          := 'Maroc';
    v_aeroport(2).nombre_pistes := 2;

    -- Insertion du troisi?me a?roport
    v_aeroport(3).code_aeroport := 'TNG';
    v_aeroport(3).nom_aeroport  := 'Ibn Battouta';
    v_aeroport(3).ville         := 'Tanger';
    v_aeroport(3).pays          := 'Maroc';
    v_aeroport(3).nombre_pistes := 1;

    -- Affichage des trois a?roports
    DBMS_OUTPUT.PUT_LINE('A?roports 1 : ( ' || v_aeroport(1).code_aeroport || ' , ' || v_aeroport(1).nom_aeroport || ' , ' || v_aeroport(1).ville || ' , ' || v_aeroport(1).pays || ' , ' ||v_aeroport(1).nombre_pistes || ' ) ' );
    DBMS_OUTPUT.PUT_LINE('A?roports 2 : ( ' || v_aeroport(2).code_aeroport || ' , ' || v_aeroport(2).nom_aeroport || ' , ' || v_aeroport(2).ville || ' , ' || v_aeroport(2).pays || ' , ' ||v_aeroport(2).nombre_pistes || ' ) ' );
    DBMS_OUTPUT.PUT_LINE('A?roports 3 : ( ' || v_aeroport(3).code_aeroport || ' , ' || v_aeroport(3).nom_aeroport || ' , ' || v_aeroport(3).ville || ' , ' || v_aeroport(3).pays || ' , ' ||v_aeroport(3).nombre_pistes || ' ) ' );

    -- Compter le nombre total d'a?roports
    nb_total := v_aeroport.COUNT;
    DBMS_OUTPUT.PUT_LINE('Nombre total d''a?roports : ' || nb_total);
END;
/

----------------------------
-- Question 4.a : 
-- SELECT INTO avec variables bas?es sur les colonnes (%TYPE)
----------------------------
DECLARE
    -- D?claration des variables bas?es sur les types des colonnes
    v_numVol VOL.ID_VOL%TYPE;
    v_marque AVION.MARQUE%TYPE;
    v_pilote PILOTE.NOM%TYPE;

BEGIN
    -- Saisie du num?ro de vol par l'utilisateur
    v_numVol := '&NUM_VOL';

    -- R?cup?ration des informations du vol avec jointures
    SELECT V.ID_VOL, A.MARQUE, P.NOM
    INTO v_numVol, v_marque, v_pilote
    FROM VOL V
    JOIN AVION A ON A.ID_AV = V.N_AVION
    JOIN PILOTE P ON P.ID_PIL = V.N_PILOTE
    WHERE V.ID_VOL = v_numVol;

    -- Affichage des informations du vol
    DBMS_OUTPUT.PUT_LINE('Vol : ' || v_numVol || ' - Avion : ' || v_marque || ' - Pilote : ' || v_pilote);
END;
/

----------------------------
-- Question 4.b : 
-- SELECT INTO avec record personnalis?
----------------------------
DECLARE
    -- D?claration d'un type record pour les informations du vol
    TYPE vol_rec_type IS RECORD (
        Id_vol      VOL.Id_vol%TYPE,
        N_Avion     VOL.N_Avion%TYPE,
        N_Pilote    VOL.N_Pilote%TYPE
    );

    -- Variable de type record
    v_vol vol_rec_type; 

BEGIN
    -- Saisie du num?ro de vol par l'utilisateur
    v_vol.Id_vol := '&id_vol';

    -- R?cup?ration des informations dans le record
    SELECT N_Avion, N_Pilote
    INTO v_vol.N_Avion, v_vol.N_Pilote
    FROM vol
    WHERE Id_vol = v_vol.Id_vol;

    -- Affichage des informations du vol
    DBMS_OUTPUT.PUT_LINE('ID du vol : ' || v_vol.Id_vol);
    DBMS_OUTPUT.PUT_LINE('Num?ro de l''avion : ' || v_vol.N_Avion);
    DBMS_OUTPUT.PUT_LINE('Num?ro du pilote : ' || v_vol.N_Pilote);
END;
/

----------------------------
-- Question 5 : 
-- Mise ? jour et insertion avec v?rifications
----------------------------
DECLARE
    -- Variables pour la mise ? jour de l'avion
    v_nouvelle_capacite   AVION.Capacite%TYPE := 600;
    v_capacite_affichee   AVION.Capacite%TYPE;

    -- Variables pour l'insertion du passager
    v_id_pas    PASSAGER.Id_Pas%TYPE := 101;        
    v_nom       PASSAGER.Nom%TYPE    := 'Tafraouti';
    v_prenom    PASSAGER.Prenom%TYPE := 'Sanae';
    v_age       PASSAGER.Age%TYPE    := 21;
    v_ville     PASSAGER.Ville%TYPE  := 'T?touan';
    v_email     PASSAGER.Email%TYPE  := 'tafraouti.sanae@gmail.com';
    v_tel       PASSAGER.Telephone%TYPE := '0600000000';

    -- Record pour r?cup?rer les donn?es du passager ins?r?
    r_passager  PASSAGER%ROWTYPE;
    v_count     NUMBER;

BEGIN
    -- 5.a : Mise ? jour de la capacit? de l'avion A380
    UPDATE avion
    SET Capacite = v_nouvelle_capacite
    WHERE Modele = 'A380';

    -- V?rification si la mise ? jour a affect? des lignes
    IF SQL%ROWCOUNT > 0 THEN
        -- R?cup?ration de la nouvelle capacit?
        SELECT Capacite INTO v_capacite_affichee
        FROM avion
        WHERE Modele = 'A380';

        DBMS_OUTPUT.PUT_LINE('Nouvelle capacit? du A380 : ' || v_capacite_affichee);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Aucun avion A380 trouv?.');
    END IF;

    -- 5.b : Insertion d'un nouveau passager
    -- V?rifier si le passager existe d?j?
    SELECT COUNT(*) INTO v_count
    FROM passager
    WHERE Id_Pas = v_id_pas;

    IF v_count = 0 THEN
        -- Insertion du nouveau passager
        INSERT INTO passager (Id_Pas, Nom, Prenom, Age, Ville, Email, Telephone)
        VALUES (v_id_pas, v_nom, v_prenom, v_age, v_ville, v_email, v_tel);

        -- R?cup?ration des donn?es du passager ins?r?
        SELECT * INTO r_passager
        FROM passager
        WHERE Id_Pas = v_id_pas;

        -- Affichage des informations du nouveau passager
        DBMS_OUTPUT.PUT_LINE('Nouveau passager ins?r? : ');
        DBMS_OUTPUT.PUT_LINE('ID : ' || r_passager.Id_Pas);
        DBMS_OUTPUT.PUT_LINE('Nom Complet : ' || r_passager.Nom || ' ' || r_passager.Prenom);
        DBMS_OUTPUT.PUT_LINE('Ville : ' || r_passager.Ville);
        DBMS_OUTPUT.PUT_LINE('Email : ' || r_passager.Email);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ce passager existe d?j?, insertion annul?e.');
    END IF;
END;
/

----------------------------
-- Question 6 : 
-- Passager avec le plus grand nombre d'heures de vol
----------------------------
DECLARE
    -- D?claration d'un type record complet pour le passager
    TYPE passager_rec_type IS RECORD (
        Id_Pas          PASSAGER.Id_Pas%TYPE,
        Nom             PASSAGER.Nom%TYPE,
        Prenom          PASSAGER.Prenom%TYPE,
        Age             PASSAGER.Age%TYPE,
        Ville           PASSAGER.Ville%TYPE,
        Email           PASSAGER.Email%TYPE,
        Telephone       PASSAGER.Telephone%TYPE,
        Numero_passport PASSAGER.Numero_passport%TYPE,
        Heure_vols      PASSAGER.Heure_vols%TYPE,
        Programme_fidelite PASSAGER.Programme_fidelite%TYPE
    );
    
    -- Variable de type record pour stocker les donn?es du passager
    v_passager passager_rec_type; 

BEGIN
    -- R?cup?ration du passager avec le maximum d'heures de vol
    SELECT Id_Pas, Nom, Prenom, Age, Ville, Email, Telephone, Numero_passport, Heure_vols, Programme_fidelite
    INTO v_passager
    FROM passager
    WHERE Heure_vols = (SELECT MAX(Heure_vols) FROM passager);

    -- Affichage des informations compl?tes du passager
    DBMS_OUTPUT.PUT_LINE('Passager avec le plus grand nombre d''heures de vol :');
    DBMS_OUTPUT.PUT_LINE('ID : ' || v_passager.Id_Pas);
    DBMS_OUTPUT.PUT_LINE('Nom : ' || v_passager.Nom);
    DBMS_OUTPUT.PUT_LINE('Pr?nom : ' || v_passager.Prenom);
    DBMS_OUTPUT.PUT_LINE('Age : ' || v_passager.Age);
    DBMS_OUTPUT.PUT_LINE('Ville : ' || v_passager.Ville);
    DBMS_OUTPUT.PUT_LINE('Email : ' || v_passager.Email);
    DBMS_OUTPUT.PUT_LINE('T?l?phone : ' || v_passager.Telephone);
    DBMS_OUTPUT.PUT_LINE('Num?ro de passeport : ' || v_passager.Numero_passport);
    DBMS_OUTPUT.PUT_LINE('Heures de vol : ' || v_passager.Heure_vols);
    DBMS_OUTPUT.PUT_LINE('Programme fid?lit? : ' || v_passager.Programme_fidelite);
END;
/