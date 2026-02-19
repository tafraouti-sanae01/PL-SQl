-- UTILISATION D’UN CURSEUR EXPLICITE
/*
Fonctionnement Technique
Zone mémoire : Oracle stocke le résultat de la requête dans une zone mémoire.

Curseur : C’est un nom donné à cette zone mémoire pour y accéder.

Parcours : On peut avancer ligne par ligne dans cette zone avec le curseur.

Types de Curseurs
Curseurs Implicites : Créés automatiquement par Oracle.

Pour INSERT, UPDATE, DELETE

Pour SELECT qui retourne une seule ligne

Curseurs Explicites : Créés manuellement par le développeur.

Pour SELECT qui retourne plusieurs lignes

Permettent un contrôle fin du parcours
*/

-- Les 4 Étapes Obligatoires
DECLARE
    -- 1. Déclaration
    CURSOR cur_employés IS SELECT id, nom, salaire FROM employés;
    
    -- Variables pour stocker chaque ligne
    v_id employés.id%TYPE;
    v_nom employés.nom%TYPE;
    v_salaire employés.salaire%TYPE;
BEGIN
    -- 2. Ouverture
    OPEN cur_employés;
    
    -- 3. Traitement ligne par ligne
    LOOP
        FETCH cur_employés INTO v_id, v_nom, v_salaire;
        
        -- Si plus de lignes, on sort
        EXIT WHEN cur_employés%NOTFOUND;
        
        -- Traitement de la ligne
        DBMS_OUTPUT.PUT_LINE(v_nom || ' gagne ' || v_salaire);
    END LOOP;
    
    -- 4. Fermeture
    CLOSE cur_employés;
END;
/

-- MANIPULATION AVANCÉE DES CURSEURS
-- Utilisation avec %ROWTYPE
DECLARE
    CURSOR cur_employés IS
        SELECT * FROM employés;
    
    v_employé employés%ROWTYPE;  -- Contient TOUTES les colonnes
BEGIN
    OPEN cur_employés;
    
    LOOP
        FETCH cur_employés INTO v_employé;
        EXIT WHEN cur_employés%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || v_employé.id || 
            ', Nom: ' || v_employé.nom || 
            ', Salaire: ' || v_employé.salaire
        );
    END LOOP;
    
    CLOSE cur_employés;
END;
/

-- Curseurs avec Paramètres
DECLARE
    -- Curseur avec paramètre
    CURSOR cur_employés_par_dept(p_département VARCHAR2) IS
        SELECT * FROM employés 
        WHERE département = p_département;
    
    v_employé employés%ROWTYPE;
BEGIN
    -- Ouverture avec paramètre
    OPEN cur_employés_par_dept('Ventes');
    
    LOOP
        FETCH cur_employés_par_dept INTO v_employé;
        EXIT WHEN cur_employés_par_dept%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(v_employé.nom);
    END LOOP;
    
    CLOSE cur_employés_par_dept;
END;
/

/*
Attributs des Curseurs
%ISOPEN : VRAI si le curseur est ouvert

%FOUND : VRAI si le dernier FETCH a retourné une ligne

%NOTFOUND : VRAI si le dernier FETCH n'a PAS retourné de ligne

%ROWCOUNT : Nombre de lignes déjà récupérées
*/

-- GESTION AUTOMATIQUE AVEC FOR LOOP
-- Syntaxe Simplifiée
DECLARE
    CURSOR cur_employés IS SELECT * FROM employés;
BEGIN
    -- Tout est automatique !
    FOR emp IN cur_employés LOOP
        DBMS_OUTPUT.PUT_LINE(emp.nom || ' - ' || emp.département);
    END LOOP;
END;
/

-- Avec paramètres
DECLARE
    CURSOR cur_employés_par_salaire(p_salaire_min NUMBER) IS
        SELECT * FROM employés 
        WHERE salaire > p_salaire_min;
BEGIN
    FOR emp IN cur_employés_par_salaire(3000) LOOP
        DBMS_OUTPUT.PUT_LINE(emp.nom || ' gagne ' || emp.salaire);
    END LOOP;
END;
/
-- Même sans déclarer explicitement le curseur !
BEGIN
    -- Curseur implicite dans la boucle FOR
    FOR emp IN (SELECT * FROM employés WHERE département = 'Ventes') LOOP
        DBMS_OUTPUT.PUT_LINE(emp.nom);
    END LOOP;
END;
/

--  MISE À JOUR AVEC CURSEURS
-- FOR UPDATE
DECLARE
    CURSOR cur_employés IS
        SELECT * FROM employés 
        WHERE département = 'Ventes'
        FOR UPDATE;  -- Verrouille les lignes
BEGIN
    FOR emp IN cur_employés LOOP
        -- Augmentation de 10% pour les vendeurs
        UPDATE employés 
        SET salaire = salaire * 1.10
        WHERE CURRENT OF cur_employés;  -- Modifie la ligne COURANTE du curseur
    END LOOP;
    
    COMMIT;  -- Valide les modifications
END;
/

-- PAGE 19 : EXERCICE PRATIQUE
DECLARE
    CURSOR cur_commerciaux IS
        SELECT nom, prénom, salaire 
        FROM salariés 
        WHERE fonction = 'Commercial'
        ORDER BY nom;
    
    v_nom salariés.nom%TYPE;
    v_prénom salariés.prénom%TYPE;
    v_salaire salariés.salaire%TYPE;
BEGIN
    OPEN cur_commerciaux;
    
    DBMS_OUTPUT.PUT_LINE('=== LISTE DES COMMERCIAUX ===');
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
    
    LOOP
        FETCH cur_commerciaux INTO v_nom, v_prénom, v_salaire;
        EXIT WHEN cur_commerciaux%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_nom || ' ' || v_prénom, 30) || 
            'Salaire: ' || v_salaire
        );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
    DBMS_OUTPUT.PUT_LINE('Total: ' || cur_commerciaux%ROWCOUNT || ' commerciaux');
    
    CLOSE cur_commerciaux;
END;
/

-- LES EXCEPTIONS
BEGIN
    -- Code normal
    v_résultat := 100 / v_diviseur;
    
EXCEPTION  -- Si une erreur se produit
    WHEN ZERO_DIVIDE THEN  -- Si c'est une division par zéro
        DBMS_OUTPUT.PUT_LINE('Erreur : Division par zéro !');
    WHEN OTHERS THEN  -- Pour toute autre erreur
        DBMS_OUTPUT.PUT_LINE('Erreur inconnue');
END;
/
-- NO_DATA_FOUND
-- TOO_MANY_ROWS
-- DUP_VAL_ON_INDEX : Violation d'unicité (doublon sur clé primaire)

-- TYPES D'EXCEPTIONS
-- 1. Exceptions Prédéfinies (déjà connues d'Oracle)
DECLARE
    v_nom employés.nom%TYPE;
BEGIN
    -- Essaie de trouver un employé avec ID = 999 (n'existe probablement pas)
    SELECT nom INTO v_nom FROM employés WHERE id = 999;
    
    DBMS_OUTPUT.PUT_LINE('Nom: ' || v_nom);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun employé trouvé avec cet ID');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Plusieurs employés ont cet ID (anomalie)');
END;
/

-- 2. Exceptions Définies par l'Utilisateur
DECLARE
    -- 1. Déclaration de l'exception
    salaire_trop_bas EXCEPTION;
    
    v_salaire employés.salaire%TYPE := 800;
    v_salaire_min CONSTANT NUMBER := 1200;
BEGIN
    -- 2. Vérification conditionnelle
    IF v_salaire < v_salaire_min THEN
        -- 3. Déclenchement manuel
        RAISE salaire_trop_bas;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Salaire OK');
    
EXCEPTION
    -- 4. Interception
    WHEN salaire_trop_bas THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Le salaire est inférieur au minimum légal (' || v_salaire_min || ')');
END;
/

-- 3. Exceptions Internes (avec code d'erreur)
DECLARE
    -- 1. Déclaration
    violation_clé_étrangère EXCEPTION;
    
    -- 2. Association au code d'erreur Oracle
    PRAGMA EXCEPTION_INIT(violation_clé_étrangère, -2292);
BEGIN
    -- Essaie de supprimer un département qui a des employés
    DELETE FROM départements WHERE id = 10;
    
EXCEPTION
    -- 3. Interception
    WHEN violation_clé_étrangère THEN
        DBMS_OUTPUT.PUT_LINE('Impossible de supprimer : des employés dépendent de ce département');
END;
/

-- FONCTIONS UTILES ET BONNES PRATIQUES
-- SQLCODE : Retourne le code numérique de l'erreur
-- SQLERRM : Retourne le message d'erreur

DECLARE
    v_id employés.id%TYPE := 100;
    v_nom employés.nom%TYPE;
    
    -- Exception personnalisée
    employé_inactif EXCEPTION;
BEGIN
    -- Vérifie si l'employé est actif
    SELECT nom INTO v_nom 
    FROM employés 
    WHERE id = v_id AND statut = 'ACTIF';
    
    IF v_nom IS NULL THEN
        RAISE employé_inactif;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Employé actif : ' || v_nom);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employé ' || v_id || ' non trouvé');
        
    WHEN employé_inactif THEN
        DBMS_OUTPUT.PUT_LINE('Employé ' || v_id || ' est inactif');
        
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR INATTENDUE :');
        DBMS_OUTPUT.PUT_LINE('  Code : ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('  Message : ' || SQLERRM);
        
        -- On peut aussi logger dans une table
        INSERT INTO logs_erreurs (code, message, date_erreur)
        VALUES (SQLCODE, SQLERRM, SYSDATE);
        
        COMMIT;
END;
/

-- Exemple Intégré Final
DECLARE
    -- Curseur avec exception
    CURSOR cur_employés_critiques IS
        SELECT id, nom, salaire 
        FROM employés 
        WHERE salaire < 1500
        FOR UPDATE;
    
    -- Exception personnalisée
    salaire_trop_bas EXCEPTION;
    
    v_id employés.id%TYPE;
    v_nom employés.nom%TYPE;
    v_salaire employés.salaire%TYPE;
BEGIN
    OPEN cur_employés_critiques;
    
    DBMS_OUTPUT.PUT_LINE('=== REVISION DES SALAIRES BAS ===');
    
    LOOP
        FETCH cur_employés_critiques INTO v_id, v_nom, v_salaire;
        EXIT WHEN cur_employés_critiques%NOTFOUND;
        
        BEGIN  -- Sous-bloc pour gestion fine
            -- Validation
            IF v_salaire < 1200 THEN
                RAISE salaire_trop_bas;
            END IF;
            
            -- Augmentation
            UPDATE employés 
            SET salaire = salaire * 1.15
            WHERE CURRENT OF cur_employés_critiques;
            
            DBMS_OUTPUT.PUT_LINE(v_nom || ': +15% (nouveau: ' || (v_salaire*1.15) || ')');
            
        EXCEPTION
            WHEN salaire_trop_bas THEN
                DBMS_OUTPUT.PUT_LINE('ERREUR: ' || v_nom || ' a un salaire trop bas: ' || v_salaire);
        END;
    END LOOP;
    
    CLOSE cur_employés_critiques;
    
    DBMS_OUTPUT.PUT_LINE('=== TRAITEMENT TERMINE ===');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR GLOBALE: ' || SQLERRM);
        IF cur_employés_critiques%ISOPEN THEN
            CLOSE cur_employés_critiques;
        END IF;
        ROLLBACK;  -- Annule toutes les modifications
END;
/

