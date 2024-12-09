#include <libpq-fe.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void printJSON(PGresult* result) {
  int n = 0, r = 0;
  int nrows = PQntuples(result);
  int nfields = PQnfields(result);

  Oid coltype;

  printf("[");

  for (r = 0; r < nrows; r++) {
    printf("{");

    for (n = 0; n < nfields; n++) {
      coltype = PQftype(result, n);

      // nazwa kolumny
      printf("\"%s\":", PQfname(result, n));

      // wartosc w kolumnie

      // czy null?
      if (PQgetisnull(result, r, n)) {
        printf("null");
      } else {
        if (coltype == 20 || coltype == 21 || coltype == 23 || coltype == 700 ||
            coltype == 701 || coltype == 1700) {
          printf("%s", PQgetvalue(result, r, n));
        } else if (coltype == 16) {
          if (strcmp(PQgetvalue(result, r, n), "f") == 0) {
            printf("false");
          } else {
            printf("true");
          }
        } else {
          printf("\"%s\"", PQgetvalue(result, r, n));
        }
      }

      if (n != nfields - 1) {
        printf(",");
      }
    }

    if (r == nrows - 1) {
      printf("}");
    } else {
      printf("},");
    }
  }

  printf("]\n");
}

/*
przykladowe wywolania programu:
./a.out 'SELECT * FROM czytelnik;'

./a.out 'select c.nazwisko,
       sum(
               case when wk.ksiazka_id = 1 then 1 else 0 end
       ) as "Wiedźmin",
       sum(
               case when wk.ksiazka_id = 2 then 1 else 0 end
       ) as "Lalka",
       sum(
               case when wk.ksiazka_id = 3 then 1 else 0 end
       ) as "Krzyżacy",
       sum(
               case when wk.ksiazka_id = 4 then 1 else 0 end
       ) as "Pan Tadeusz"
from czytelnik c
         join wypozyczenie w on c.czytelnik_id = w.czytelnik_id
         join wypozyczenie_ksiazki wk on w.wypozyczenie_id = wk.wypozyczenie_id
group by c.nazwisko;'

./a.out 'SELECT TRUE as true, FALSE as false, NULL as null;'
*/

int main(int argc, char const* argv[]) {
  if (argc != 2) {
    printf("No SQL provided. Use ./json <QUERY>\n");
    return EXIT_FAILURE;
  }

  const char* query = argv[1];

  const char* connection_str =
      "host=ep-soft-hat-a2aw7vto.eu-central-1.aws.neon.tech port=5432 "
      "dbname=BDlab user=BDlab_owner password=f8we7mZyGXDQ";

  PGresult* result;
  PGconn* conn = PQconnectdb(connection_str);
  if (PQstatus(conn) == CONNECTION_BAD) {
    fprintf(stderr, "Connection to %s failed, %s", connection_str,
            PQerrorMessage(conn));
  } else {
    printf("Connected OK\n");
    // tutaj musze ustawic schemat pierw
    PQexec(conn, "set search_path to biblioteka;");

    result = PQexec(conn, query);
    printJSON(result);

    PQfinish(conn);
    return 0;
  }
}
