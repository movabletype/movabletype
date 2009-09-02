all: postgres sqlite mysql oracle

SQL = mt.sql

mysql: $(SQL)
	rm -f mysql.schema
	touch mysql.schema
	for i in $(SQL); do\
		./sqlmangle mysql $$i >> mysql.schema\
	; done
	chmod -w mysql.schema


postgres: $(SQL)
	rm -f postgres.schema
	touch postgres.schema
	for i in $(SQL); do\
		./sqlmangle postgres $$i >> postgres.schema\
	; done
	chmod -w postgres.schema

sqlite: $(SQL)
	rm -f sqlite.schema
	touch sqlite.schema
	for i in $(SQL); do\
		./sqlmangle sqlite $$i >> sqlite.schema\
	; done
	chmod -w sqlite.schema

oracle: $(SQL)
	rm -f oracle.schema
	touch oracle.schema
	for i in $(SQL); do\
		./sqlmangle oracle $$i >> oracle.schema\
	; done
	chmod -w oracle.schema
