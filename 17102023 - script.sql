DO $$
DECLARE
	v_resultado BOOLEAN;
BEGIN
	SELECT 
		fn_algum('fn_eh_negativo', 1, 2, 5, -1)
	INTO v_Resultado;
	RAISE NOTICE '%', CASE WHEN v_resultado = TRUE THEN
'Sim, tem negativos' ELSE 'Não, não tem negativos' END;
END;
$$


-- --[1, 2, 5, 4, 3, 1, 7, 8]

CREATE OR REPLACE FUNCTION fn_eh_negativo(
	IN p_numero INT
) RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
BEGIN
	RETURN 
		CASE 
			WHEN p_numero < 0 
				THEN TRUE ELSE FALSE 
		END;
END;
$$

CREATE  FUNCTION fn_algum(
	IN p_fn_executa TEXT,
	VARIADIC p_elementos INT[]
) RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
	v_elemento INT;
	v_resultado BOOLEAN;
BEGIN
	FOREACH v_elemento IN ARRAY p_elementos LOOP
		EXECUTE format( --SELECT p_fn_executa(1)
			'SELECT %s (%s)', 
			p_fn_executa,
			v_elemento
		) INTO v_resultado;
		IF v_resultado = TRUE THEN
			RETURN TRUE;
		END IF;		
	END LOOP;
	RETURN FALSE;
END;
$$

DROP FUNCTION fn_algum;

--chamando sem bloco anônimo
-- SELECT fn_hello();
--chamando com bloco anônimo
-- DO $$
-- DECLARE
-- 	v_resultado TEXT;
-- BEGIN
-- 	SELECT fn_hello () INTO v_resultado;
-- 	RAISE NOTICE '%', v_resultado;
-- 	--v_resultado := fn_hello ();
-- 	--RAISE NOTICE '%', v_resultado;
-- 	--executando e descartando o resultado
-- 	PERFORM fn_hello();
-- 	--assim não rola, CALL apenas para procs
-- 	--CALL fn_hello();
-- END
-- $$

-- CREATE OR REPLACE FUNCTION fn_hello()
-- RETURNS TEXT LANGUAGE plpgsql AS $$
-- BEGIN
-- 	RETURN 'Hellom Functions!';
-- END;
-- $$