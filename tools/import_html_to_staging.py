
import json
import re
from pathlib import Path

SOURCE_FILE = Path("legacy/annuaire-initial.html")
OUTPUT_FILE = Path("database/imports/V3__stage_annuaire_data.sql")

GROUPS = [
    "secondary",
    "primary",
    "privatePrimary",
    "preschool",
    "inspection",
]


def sql_string(value):
    """Convertit une valeur Python en chaîne SQL MySQL."""
    return "'" + str(value).replace("\\", "\\\\").replace("'", "''") + "'"


def main():
    if not SOURCE_FILE.exists():
        raise FileNotFoundError(
            f"Fichier source introuvable : {SOURCE_FILE}"
        )

    html = SOURCE_FILE.read_text(encoding="utf-8")

    match = re.search(
        r'<script\s+id=["\']data["\']\s+type=["\']application/json["\']>'
        r'(.*?)</script>',
        html,
        re.DOTALL | re.IGNORECASE
    )

    if not match:
        raise ValueError(
            "Le bloc JSON <script id='data'> est introuvable."
        )

    data = json.loads(match.group(1))

    sql_lines = [
        "USE annuaire_scolaire;",
        "START TRANSACTION;",
        "",
        "-- Enregistrement du fichier source",
        """
INSERT INTO source_document
(nom_fichier, type_document, date_document, description)
VALUES
(
    'annuaire-initial.html',
    'HTML',
    NULL,
    'Compilation des donnees de l annuaire scolaire Sfax 2'
);
""",
        "SET @source_document_id = LAST_INSERT_ID();",
        "",
    ]

    total = sum(
        len(data.get(group, []))
        for group in GROUPS
    )

    sql_lines.extend([
        "-- Creation du lot d importation",
        f"""
INSERT INTO import_batch
(source_document_id, nom_import, statut, nombre_lus)
VALUES
(@source_document_id, 'IMPORT_HTML_SFAX2', 'PENDING', {total});
""",
        "SET @batch_id = LAST_INSERT_ID();",
        "",
    ])

    for group in GROUPS:
        records = data.get(group, [])

        if not isinstance(records, list):
            raise ValueError(f"Le groupe {group} n'est pas une liste.")

        for index, record in enumerate(records, start=1):
            payload = {
                "_source_group": group,
                "_source_index": index,
                "record": record,
            }

            json_value = json.dumps(
                payload,
                ensure_ascii=False,
                separators=(",", ":")
            )

            source_key = f"{group}-{index}"

            sql_lines.append(
                "INSERT INTO import_staging_record "
                "(import_batch_id, source_record_key, donnees_brutes, statut) "
                f"VALUES (@batch_id, {sql_string(source_key)}, "
                f"CAST({sql_string(json_value)} AS JSON), 'PENDING');"
            )

    sql_lines.extend([
        "",
        f"""
UPDATE import_batch
SET statut = 'STAGED',
    nombre_lus = {total},
    nombre_importes = 0,
    nombre_erreurs = 0,
    finished_at = CURRENT_TIMESTAMP
WHERE id = @batch_id;
""",
        "COMMIT;",
        "",
    ])

    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_FILE.write_text(
        "\n".join(sql_lines),
        encoding="utf-8"
    )

    print("Extraction terminee.")
    print(f"Groupes : {len(GROUPS)}")
    for group in GROUPS:
        print(f"  {group}: {len(data.get(group, []))} enregistrements")

    print(f"Total : {total}")
    print(f"Fichier SQL genere : {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
