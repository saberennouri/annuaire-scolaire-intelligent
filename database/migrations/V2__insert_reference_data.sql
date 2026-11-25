
USE annuaire_scolaire;

-- Delegations du gouvernorat de Sfax
INSERT INTO delegation (code, nom_ar, nom_fr) VALUES
('SFAX_SUD', 'صفاقس الجنوبية', 'Sfax Sud'),
('SAKIET_EDDAIER', 'ساقية الدائر', 'Sakiet Eddaier'),
('SAKIET_EZZIT', 'ساقية الزيت', 'Sakiet Ezzit'),
('EL_HENCHA', 'الحنشة', 'El Hencha'),
('MENZEL_CHAKER', 'منزل شاكر', 'Menzel Chaker'),
('JEBINIANA', 'جبنيانة', 'Jebiniana'),
('EL_AMRA', 'العامرة', 'El Amra'),
('KERKENNAH', 'قرقنة', 'Kerkennah');

-- Types d'etablissements
INSERT INTO type_etablissement (code, libelle_fr, libelle_ar) VALUES
('COLLEGE', 'Collège', 'إعدادية'),
('LYCEE', 'Lycée', 'معهد ثانوي'),
('PRIMARY_PUBLIC', 'École primaire publique', 'مدرسة ابتدائية عمومية'),
('PRIMARY_PRIVATE', 'École primaire privée', 'مدرسة ابتدائية خاصة'),
('PRESCHOOL_PRIVATE', 'Établissement préscolaire privé', 'مؤسسة طفولة مبكرة خاصة');

-- Roles des responsables
INSERT INTO role_responsable (code, libelle_fr, libelle_ar) VALUES
('DIRECTOR', 'Directeur', 'مدير'),
('CENSEUR', 'Censeur', 'قيم عام'),
('SG1', 'Surveillant général 1', 'قيم أول'),
('SG2', 'Surveillant général 2', 'قيم ثان'),
('ASSISTANT', 'Assistant', 'مساعد'),
('SECRETARY', 'Secrétaire', 'كاتب'),
('CLERK', 'Commis', 'عون');
