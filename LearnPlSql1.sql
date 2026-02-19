SET SERVEROUTPUT ON;
/*
SQL (manipulation de données) 
+ 
Programmation procédurale (logique métier)
=
PL/SQL (traitements complexes)
*/

/*
CLIENT (SQL Developer, SQL*Plus)
    |
    |-- Envoie un bloc PL/SQL
    |
SERVEUR ORACLE
    |-- Moteur PL/SQL (exécute la logique procédurale)
    |-- Moteur SQL (exécute les requêtes SQL)
*/

-- Structure de base
DECLARE
    -- Déclarations (variables, constantes, curseurs)
BEGIN
    -- Instructions exécutables (corps du programme)
EXCEPTION
    -- Gestion des erreurs
END;
/

DECLARE
    v_nom VARCHAR2(50) := 'Alice';
    v_age INTEGER := 30;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Nom : ' || v_nom);
    DBMS_OUTPUT.PUT_LINE('Âge : ' || v_age);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur inattendue');
END;
/

-- DÉCLARATION DES VARIABLES
DECLARE
    -- Variable simple
    v_age INTEGER;
    
    -- Variable avec valeur par défaut
    v_salaire NUMBER(8,2) := 2500.50;
    
    -- Constante
    c_tva CONSTANT NUMBER := 0.20;
    
    -- NOT NULL
    v_nom VARCHAR2(50) NOT NULL := 'Inconnu';
BEGIN
    v_age := 25;
    DBMS_OUTPUT.PUT_LINE('Nom : ' || v_nom || ', Âge : ' || v_age);
END;
/

-- OPÉRATEURS
DECLARE
    v_a NUMBER := 10;
    v_b NUMBER := 5;
    v_resultat NUMBER;
    v_texte VARCHAR2(100);
BEGIN
    -- Arithmétique
    v_resultat := v_a + v_b; -- 15
    
    -- Concaténation
    v_texte := 'Résultat : ' || v_resultat;
    
    -- Comparaison
    IF v_a > v_b THEN
        DBMS_OUTPUT.PUT_LINE(v_a || ' > ' || v_b);
    END IF;
END;
/

-- TYPES DE DONNÉES
DECLARE
    -- Numérique
    v_salaire NUMBER(8,2); -- 8 chiffres, 2 décimales
    v_age INTEGER;
    
    -- Caractère
    v_nom VARCHAR2(50);
    v_description CLOB; -- Texte très long
    
    -- Date
    v_date_embauche DATE;
    
    -- Booléen
    v_actif BOOLEAN := TRUE;
BEGIN
    NULL;
END;
/

-- AFFECTATION DES VARIABLES
DECLARE
    -- Initialisation à la déclaration
    v_message VARCHAR2(100) DEFAULT 'Bonjour';
    
    -- Sans initialisation
    v_ville VARCHAR2(50);
BEGIN
    -- Affectation dans BEGIN
    v_ville := 'Tétouan';
    
    -- Affichage
    DBMS_OUTPUT.PUT_LINE(v_message || ' de ' || v_ville);
END;
/

--  PORTÉE ET CONVERSION
-- 1. Portée des variables
DECLARE
    -- Variable globale
    v_globale NUMBER := 100;
BEGIN
    DECLARE
        -- Variable locale (masque la globale)
        v_globale NUMBER := 200;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Locale : ' || v_globale); -- 200
    END;
    
    DBMS_OUTPUT.PUT_LINE('Globale : ' || v_globale); -- 100
END;
/

--2.Conversion de types
-- > Explicite
-- DATE vers CHAR
v_date_texte := TO_CHAR(SYSDATE, 'DD/MM/YYYY');

-- CHAR vers NUMBER
v_nombre := TO_NUMBER('123.45');

-- CHAR vers DATE
v_date := TO_DATE('15/01/2024', 'DD/MM/YYYY');

-- > Implicite (automatique, à éviter)
-- Oracle convertit automatiquement
v_nombre := '100'; -- CHAR ? NUMBER
-- Risque d'erreur si format incorrect


-- Autres types de données
-- 1. Types définis par les utilisateurs
DECLARE
subtype type_number is number(2,0);
BEGIN

END;
/

-- 2. Records (Enregistrements)
DECLARE
    -- Définition du type
    TYPE t_employe IS RECORD (
        id INTEGER,
        nom VARCHAR2(50),
        salaire NUMBER(8,2)
    );
    
    -- Déclaration d'une variable de ce type
    v_emp t_employe;
BEGIN
    -- Affectation
    v_emp.id := 1;
    v_emp.nom := 'Ali';
    v_emp.salaire := 5000;
    
    -- Affichage
    DBMS_OUTPUT.PUT_LINE('Employé : ' || v_emp.nom);
END;
/

-- 2. Collections
-- a) VARRAY (Tableau à taille fixe)
DECLARE
    TYPE t_jours IS VARRAY(7) OF VARCHAR2(10);
    v_semaine t_jours;
    v_semaine t_jours := t_jours();
    v_semaine t_jours:=t_jours(null,null,null);   
BEGIN
    v_semaine.extend(3);
    v_semaine := t_jours('Lundi', 'Mardi', 'Mercredi');
    v_semaine(1):='Lundi';
    v_semaine(2):='Mardi';
    v_semaine(3):='Mercredi';
    
    -- Accès par index
    DBMS_OUTPUT.PUT_LINE(v_semaine(1)); -- Lundi
END;
/

-- b) TABLE associative (clé-valeur)
DECLARE
    TYPE t_capitale IS TABLE OF VARCHAR2(50)INDEX BY VARCHAR2(50);
    v_capitales t_capitale;
BEGIN
    v_capitales('Maroc') := 'Rabat';
    v_capitales('France') := 'Paris';
    
    DBMS_OUTPUT.PUT_LINE(v_capitales('Maroc')); -- Rabat
END;
/

-- c) Nested table
DECLARE
    TYPE t_jours IS TABLE OF VARCHAR2(10);
    v_semaine t_jours;
    v_semaine t_jours := t_jours();
    v_semaine t_jours:=t_jours(null,null,null);   
BEGIN
    v_semaine.extend(3);
    v_semaine := t_jours('Lundi', 'Mardi', 'Mercredi');
    v_semaine(1):='Lundi';
    v_semaine(2):='Mardi';
    v_semaine(3):='Mercredi';
    
    -- Accès par index
    DBMS_OUTPUT.PUT_LINE(v_semaine(1)); -- Lundi
END;
/

-- 3. Variables basées sur des objets existants
 -- %TYPE : Même type qu'une colonne
 DECLARE
    v_nom_employe employés.nom%TYPE;
BEGIN
    SELECT nom INTO v_nom_employe 
    FROM employés WHERE id = 1;
END;
/

-- %ROWTYPE : Même structure qu'une table
DECLARE
    v_employe employés%ROWTYPE;
BEGIN
    SELECT * INTO v_employe 
    FROM employés WHERE id = 1;
    
    DBMS_OUTPUT.PUT_LINE(v_employe.nom);
END;
/

-- ORDRES SQL DANS PL/SQL
-- 1. SELECT INTO (une seule ligne)
DECLARE
    v_nom VARCHAR2(50);
    v_salaire NUMBER;
BEGIN
    SELECT nom, salaire INTO v_nom, v_salaire
    FROM employés WHERE id = 1;
END;
/
-- 2. BULK COLLECT INTO (plusieurs lignes)
DECLARE
    TYPE t_noms IS TABLE OF VARCHAR2(50);
    v_noms t_noms;
BEGIN
    SELECT nom BULK COLLECT INTO v_noms FROM employés;
    
    -- Parcourir le tableau
    FOR i IN 1..v_noms.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_noms(i));
    END LOOP;
END;
/
-- 3. UPDATE avec SET ROW
DECLARE
    v_emp employés%ROWTYPE;
BEGIN
    SELECT * INTO v_emp FROM employés WHERE id = 1;
    
    -- Modification
    v_emp.salaire := v_emp.salaire * 1.10;
    
    -- Mise à jour
    UPDATE employés SET ROW = v_emp WHERE id = 1;
END;
/

/*
4. Attributs SQL
SQL%FOUND : VRAI si des lignes ont été modifiées

SQL%NOTFOUND : VRAI si aucune ligne modifiée

SQL%ROWCOUNT : Nombre de lignes modifiées
*/
BEGIN
    UPDATE employés SET salaire = salaire * 1.05;
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' lignes modifiées');
    END IF;
END;
/


-- STRUCTURES DE CONTRÔLE
-- 1. IF-THEN-ELSE
DECLARE
    v_note NUMBER := 15;
BEGIN
    IF v_note >= 16 THEN
        DBMS_OUTPUT.PUT_LINE('Très bien');
    ELSIF v_note >= 14 THEN
        DBMS_OUTPUT.PUT_LINE('Bien');
    ELSIF v_note >= 12 THEN
        DBMS_OUTPUT.PUT_LINE('Assez bien');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insuffisant');
    END IF;
END;
/

-- 2. CASE SIMPLE
DECLARE
    v_grade CHAR(1) := 'A';
BEGIN
    CASE v_grade
        WHEN 'A' THEN DBMS_OUTPUT.PUT_LINE('Excellent');
        WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE('Très bien');
        WHEN 'C' THEN DBMS_OUTPUT.PUT_LINE('Bien');
        ELSE DBMS_OUTPUT.PUT_LINE('Non classé');
    END CASE;
END;
/

-- 3. CASE RECHERCHE
DECLARE
    v_note NUMBER := 85;
BEGIN
    CASE
        WHEN v_note >= 90 THEN DBMS_OUTPUT.PUT_LINE('A');
        WHEN v_note >= 80 THEN DBMS_OUTPUT.PUT_LINE('B');
        WHEN v_note >= 70 THEN DBMS_OUTPUT.PUT_LINE('C');
        ELSE DBMS_OUTPUT.PUT_LINE('D');
    END CASE;
END;
/

-- BOUCLES
-- 1. LOOP basique (avec EXIT)
DECLARE
    v_compteur NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Tour ' || v_compteur);
        v_compteur := v_compteur + 1;
        EXIT WHEN v_compteur > 5;
    END LOOP;
END;
/

-- 2. WHILE LOOP
DECLARE
    v_compteur NUMBER := 1;
BEGIN
    WHILE v_compteur <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE('Tour ' || v_compteur);
        v_compteur := v_compteur + 1;
    END LOOP;
END;
/

-- 3. FOR LOOP
BEGIN
    -- De 1 à 5
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('i = ' || i);
    END LOOP;
    
    -- En reverse (5 à 1)
    FOR i IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('i = ' || i);
    END LOOP;
END;
/

-- 4. FOR LOOP avec collection
DECLARE
    TYPE t_noms IS VARRAY(3) OF VARCHAR2(50);
    v_noms t_noms := t_noms('Ali', 'Reda', 'Samir');
BEGIN
    FOR i IN 1..v_noms.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_noms(i));
    END LOOP;
END;
/

-- EXEMPLE FINAL COMPLET
-- Programme qui calcule et affiche les statistiques des employés
DECLARE
    -- Variables basées sur la table
    v_nom_employe employés.nom%TYPE;
    v_salaire employés.salaire%TYPE;
    
    -- Variables calculées
    v_salaire_moyen NUMBER;
    v_nombre_employes INTEGER;
    
    -- Constante
    c_bonus CONSTANT NUMBER := 500;
BEGIN
    -- 1. Compter les employés
    SELECT COUNT(*) INTO v_nombre_employes FROM employés;
    DBMS_OUTPUT.PUT_LINE('Nombre d''employés : ' || v_nombre_employes);
    
    -- 2. Calculer le salaire moyen
    SELECT AVG(salaire) INTO v_salaire_moyen FROM employés;
    DBMS_OUTPUT.PUT_LINE('Salaire moyen : ' || ROUND(v_salaire_moyen, 2));
    
    -- 3. Parcourir les employés avec un salaire > moyenne
    FOR emp IN (SELECT nom, salaire FROM employés WHERE salaire > v_salaire_moyen) LOOP
        DBMS_OUTPUT.PUT_LINE(emp.nom || ' gagne ' || emp.salaire);
        
        -- 4. Appliquer un bonus conditionnel
        IF emp.salaire > 10000 THEN
            DBMS_OUTPUT.PUT_LINE('  -> Bonus : ' || c_bonus);
        END IF;
    END LOOP;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucune donnée trouvée');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/




