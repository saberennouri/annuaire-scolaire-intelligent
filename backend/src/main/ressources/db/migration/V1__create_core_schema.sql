
USE annuaire_scolaire;

-- =====================================================
-- V1 : SCHEMA INITIAL - ANNUAIRE SCOLAIRE
-- Compatible MySQL 8.0
-- =====================================================

-- 1. Documents sources
CREATE TABLE source_document (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom_fichier VARCHAR(255) NOT NULL,
    type_document VARCHAR(50),
    date_document DATE,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Delegations
CREATE TABLE delegation (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    nom_ar VARCHAR(150) NOT NULL,
    nom_fr VARCHAR(150),
    actif BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uk_delegation_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Types d'etablissement
CREATE TABLE type_etablissement (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    libelle_fr VARCHAR(150) NOT NULL,
    libelle_ar VARCHAR(150),
    CONSTRAINT uk_type_etablissement_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Etablissements scolaires
CREATE TABLE etablissement (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code_source VARCHAR(100),
    nom_ar VARCHAR(255) NOT NULL,
    nom_fr VARCHAR(255),
    adresse TEXT,
    delegation_id BIGINT,
    type_etablissement_id BIGINT NOT NULL,
    source_document_id BIGINT,
    note_source TEXT,
    actif BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uk_etablissement_code_source UNIQUE (code_source),

    CONSTRAINT fk_etablissement_delegation
        FOREIGN KEY (delegation_id)
        REFERENCES delegation(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_etablissement_type
        FOREIGN KEY (type_etablissement_id)
        REFERENCES type_etablissement(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_etablissement_source
        FOREIGN KEY (source_document_id)
        REFERENCES source_document(id)
        ON DELETE SET NULL,

    INDEX idx_etablissement_nom_ar (nom_ar),
    INDEX idx_etablissement_nom_fr (nom_fr),
    INDEX idx_etablissement_delegation (delegation_id),
    INDEX idx_etablissement_type (type_etablissement_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Inspections scolaires
CREATE TABLE inspection (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code_source VARCHAR(100),
    nom_ar VARCHAR(255) NOT NULL,
    nom_fr VARCHAR(255),
    adresse TEXT,
    delegation_id BIGINT,
    source_document_id BIGINT,
    note_source TEXT,
    actif BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uk_inspection_code_source UNIQUE (code_source),

    CONSTRAINT fk_inspection_delegation
        FOREIGN KEY (delegation_id)
        REFERENCES delegation(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_inspection_source
        FOREIGN KEY (source_document_id)
        REFERENCES source_document(id)
        ON DELETE SET NULL,

    INDEX idx_inspection_nom_ar (nom_ar),
    INDEX idx_inspection_delegation (delegation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Responsables : directeurs, censeurs, secretaires...
CREATE TABLE responsable (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom_complet VARCHAR(255) NOT NULL,
    nom_ar VARCHAR(255),
    fonction_libre VARCHAR(150),
    actif BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_responsable_nom (nom_complet)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Roles des responsables
CREATE TABLE role_responsable (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    libelle_fr VARCHAR(150) NOT NULL,
    libelle_ar VARCHAR(150),
    CONSTRAINT uk_role_responsable_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Affectations des responsables
-- Un responsable peut etre affecte a un etablissement
-- OU a une inspection.
-- La regle "une seule cible" sera validee dans Spring Boot.
CREATE TABLE affectation_responsable (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    responsable_id BIGINT,
    role_responsable_id BIGINT NOT NULL,
    etablissement_id BIGINT,
    inspection_id BIGINT,
    date_debut DATE,
    date_fin DATE,
    fonction_source VARCHAR(150),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_affectation_responsable
        FOREIGN KEY (responsable_id)
        REFERENCES responsable(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_affectation_role
        FOREIGN KEY (role_responsable_id)
        REFERENCES role_responsable(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_affectation_etablissement
        FOREIGN KEY (etablissement_id)
        REFERENCES etablissement(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_affectation_inspection
        FOREIGN KEY (inspection_id)
        REFERENCES inspection(id)
        ON DELETE CASCADE,

    INDEX idx_affectation_responsable (responsable_id),
    INDEX idx_affectation_etablissement (etablissement_id),
    INDEX idx_affectation_inspection (inspection_id),
    INDEX idx_affectation_role (role_responsable_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. Coordonnees des etablissements
CREATE TABLE coordonnee_etablissement (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    etablissement_id BIGINT NOT NULL,
    type_coord VARCHAR(30) NOT NULL,
    valeur VARCHAR(255) NOT NULL,
    principale BOOLEAN NOT NULL DEFAULT FALSE,
    note VARCHAR(255),

    CONSTRAINT fk_coord_etablissement
        FOREIGN KEY (etablissement_id)
        REFERENCES etablissement(id)
        ON DELETE CASCADE,

    INDEX idx_coord_etablissement (etablissement_id),
    INDEX idx_coord_etablissement_valeur (valeur)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. Coordonnees des responsables
CREATE TABLE coordonnee_responsable (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    responsable_id BIGINT NOT NULL,
    type_coord VARCHAR(30) NOT NULL,
    valeur VARCHAR(255) NOT NULL,
    principale BOOLEAN NOT NULL DEFAULT FALSE,
    note VARCHAR(255),

    CONSTRAINT fk_coord_responsable
        FOREIGN KEY (responsable_id)
        REFERENCES responsable(id)
        ON DELETE CASCADE,

    INDEX idx_coord_responsable (responsable_id),
    INDEX idx_coord_responsable_valeur (valeur)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. Historique des imports
CREATE TABLE import_batch (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    source_document_id BIGINT,
    nom_import VARCHAR(255) NOT NULL,
    statut VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    nombre_lus INT NOT NULL DEFAULT 0,
    nombre_importes INT NOT NULL DEFAULT 0,
    nombre_erreurs INT NOT NULL DEFAULT 0,
    message_erreur TEXT,
    started_at TIMESTAMP NULL,
    finished_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_import_batch_source
        FOREIGN KEY (source_document_id)
        REFERENCES source_document(id)
        ON DELETE SET NULL,

    INDEX idx_import_batch_statut (statut),
    INDEX idx_import_batch_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12. Donnees temporaires avant integration
CREATE TABLE import_staging_record (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    import_batch_id BIGINT NOT NULL,
    source_record_key VARCHAR(150),
    donnees_brutes JSON NOT NULL,
    statut VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    message_erreur TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_staging_batch
        FOREIGN KEY (import_batch_id)
        REFERENCES import_batch(id)
        ON DELETE CASCADE,

    INDEX idx_staging_batch (import_batch_id),
    INDEX idx_staging_statut (statut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
