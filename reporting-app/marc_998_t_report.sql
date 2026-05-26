CREATE FUNCTION test_report()
RETURNS TABLE(x text)
LANGUAGE sql
AS $$
SELECT 'ok'
$$
