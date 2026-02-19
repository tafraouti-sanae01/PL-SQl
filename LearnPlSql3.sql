-- COURS PL/SQL – PARTIE 3 : PROGRAMMES STOCKÉS, TRIGGERS ET PACKAGES
-- 1: PROCÉDURES
/*
LES PROCÉDURES STOCKÉES
Qu'est-ce qu'une Procédure Stockée ?
Une procédure stockée est un programme PL/SQL nommé qui est enregistré 
dans la base de données et peut être appelé plusieurs fois. C’est comme une 
recette de cuisine stockée dans un livre : vous l'appelez quand vous en avez besoin,
sans avoir à réécrire les étapes à chaque fois.
*/
-- Structure d'une Procédure
CREATE [OR REPLACE] PROCEDURE nom_procédure
(
    param1 [IN | OUT | IN OUT] type,
    param2 [IN | OUT | IN OUT] type,
    ...
)
IS
    -- Variables locales
BEGIN
    -- Instructions
EXCEPTION
    -- Gestion des erreurs
END nom_procédure;
/

-- Types de Paramètres
-- 1. Exemple Simple Sans Paramètre
-- Création
CREATE OR REPLACE PROCEDURE dire_bonjour
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Bonjour tout le monde !');
END dire_bonjour;
/

-- Appel
EXEC dire_bonjour;
-- ou
BEGIN
    dire_bonjour;
END;
/

-- 2. Exemple Avec Paramètres IN
CREATE OR REPLACE PROCEDURE augmenter_salaire (
    p_id_employe IN NUMBER,
    p_pourcentage IN NUMBER
)
IS
    v_nouveau_salaire NUMBER;
BEGIN
    -- Mise à jour
    UPDATE employés 
    SET salaire = salaire * (1 + p_pourcentage/100)
    WHERE id = p_id_employe;
    
    -- Vérification
    SELECT salaire INTO v_nouveau_salaire
    FROM employés
    WHERE id = p_id_employe;
    
    DBMS_OUTPUT.PUT_LINE('Nouveau salaire : ' || v_nouveau_salaire);
    
    COMMIT;
END augmenter_salaire;
/

-- Appel
EXEC augmenter_salaire(101, 10); -- Augmente de 10% l'employé 101

-- 3. Exemple Avec Paramètre OUT
CREATE OR REPLACE PROCEDURE calculer_moyenne_salaire (
    p_departement IN VARCHAR2,
    p_moyenne OUT NUMBER
)
IS
BEGIN
    SELECT AVG(salaire) INTO p_moyenne
    FROM employés
    WHERE département = p_departement;
END calculer_moyenne_salaire;
/

-- Appel avec paramètre OUT
DECLARE
    v_moyenne NUMBER;
BEGIN
    calculer_moyenne_salaire('Ventes', v_moyenne);
    DBMS_OUTPUT.PUT_LINE('Moyenne salaire Ventes : ' || v_moyenne);
END;
/

-- 4. Exemple Avec Paramètre IN OUT
CREATE OR REPLACE PROCEDURE inverser_nombres (
    p_a IN OUT NUMBER,
    p_b IN OUT NUMBER
)
IS
    v_temp NUMBER;
BEGIN
    v_temp := p_a;
    p_a := p_b;
    p_b := v_temp;
END inverser_nombres;
/

-- Appel
DECLARE
    x NUMBER := 10;
    y NUMBER := 20;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Avant : x=' || x || ', y=' || y);
    inverser_nombres(x, y);
    DBMS_OUTPUT.PUT_LINE('Après : x=' || x || ', y=' || y);
END;
/

-- 2:LES FONCTIONS
CREATE [OR REPLACE] FUNCTION nom_fonction
(
    param1 type,
    param2 type,
    ...
)
RETURN type_retour
IS
    -- Variables locales
BEGIN
    -- Instructions
    RETURN valeur;
EXCEPTION
    -- Gestion erreurs
END nom_fonction;
/

-- > Exemple avec Paramètres
-- Calcul du salaire annuel (salaire mensuel * 12 + commission)
CREATE OR REPLACE FUNCTION calculer_salaire_annuel (
    p_id_employe NUMBER
)
RETURN NUMBER
IS
    v_salaire_mensuel NUMBER;
    v_commission NUMBER;
    v_salaire_annuel NUMBER;
BEGIN
    SELECT salaire, NVL(commission, 0)
    INTO v_salaire_mensuel, v_commission
    FROM employés
    WHERE id = p_id_employe;
    
    v_salaire_annuel := (v_salaire_mensuel * 12) + v_commission;
    
    RETURN v_salaire_annuel;
END calculer_salaire_annuel;
/

-- Appel
DECLARE
    v_salaire NUMBER;
BEGIN
    v_salaire := calculer_salaire_annuel(101);
    DBMS_OUTPUT.PUT_LINE('Salaire annuel : ' || v_salaire);
END;
/

-- Utilisation dans SQL
SELECT nom, calculer_salaire_annuel(id) AS salaire_annuel
FROM employés;


-- SOUS-PROGRAMMES
CREATE OR REPLACE PROCEDURE traiter_commande (
    p_id_commande NUMBER,
    p_nouveau_prix NUMBER,
    p_ancien_prix OUT NUMBER
)
IS
    -- Sous-fonction interne
    FUNCTION obtenir_ancien_prix (
        p_id_cmd NUMBER
    ) RETURN NUMBER
    IS
        v_prix NUMBER;
    BEGIN
        SELECT prix INTO v_prix
        FROM commandes
        WHERE id = p_id_cmd;
        
        RETURN v_prix;
    END obtenir_ancien_prix;
    
BEGIN
    -- Utilisation de la sous-fonction
    p_ancien_prix := obtenir_ancien_prix(p_id_commande);
    
    -- Mise à jour
    UPDATE commandes 
    SET prix = p_nouveau_prix
    WHERE id = p_id_commande;
    
    COMMIT;
END traiter_commande;
/

