CREATE OR REPLACE PROCEDURE generate_alter_statement(
    TABLE_NAME VARCHAR,
    COLUMN_NAMES ARRAY,
    DATA_TYPES ARRAY,
    DDL_TYPE VARCHAR
)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    ALTER_STMT VARCHAR;
BEGIN
    ALTER_STMT := '';
    
    IF DDL_TYPE = 'Add' THEN
        FOR i IN 1..ARRAY_SIZE(COLUMN_NAMES) LOOP
            ALTER_STMT := ALTER_STMT || 'ALTER TABLE IF EXISTS ' || TABLE_NAME || ' ADD COLUMN IF NOT EXISTS ' || COLUMN_NAMES[i] || ' ' || DATA_TYPES[i] || '; ';
        END LOOP;
    ELSIF DDL_TYPE = 'Drop' THEN
        FOR i IN 1..ARRAY_SIZE(COLUMN_NAMES) LOOP
            ALTER_STMT := ALTER_STMT || 'ALTER TABLE IF EXISTS ' || TABLE_NAME || ' DROP COLUMN IF EXISTS ' || COLUMN_NAMES[i] || '; ';
        END LOOP;
    ELSE
        ALTER_STMT := 'Invalid DDL type. Please specify either "Add" or "Drop".';
    END IF;
    
    RETURN ALTER_STMT;
END;
$$;