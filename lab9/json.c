/* Processed by ecpg (17.2) */
/* These include files are added by the preprocessor */
#include <ecpglib.h>
#include <ecpgerrno.h>
#include <sqlca.h>
/* End of automatic include section */

#line 1 "json.sqc"
#include <stdio.h>
#include <stdlib.h>

/* exec sql begin declare section */
        
        
        
     
     
     
     
     

#line 5 "json.sqc"
 const char * db = "BDlab@ep-soft-hat-a2aw7vto.eu-central-1.aws.neon.tech" ;
 
#line 6 "json.sqc"
 const char * usr = "BDlab_owner" ;
 
#line 7 "json.sqc"
 const char * pas = "f8we7mZyGXDQ" ;
 
#line 8 "json.sqc"
 char fname [ 40 ] ;
 
#line 9 "json.sqc"
 char lname [ 40 ] ;
 
#line 10 "json.sqc"
 char book_title [ 40 ] ;
 
#line 11 "json.sqc"
 int book_id ;
 
#line 12 "json.sqc"
 int id ;
/* exec sql end declare section */
#line 13 "json.sqc"


int main(int argc, char *argv[]) {
  if (argc <= 1) {
    return 1;
  }

    id = atoi(argv[1]);

    // ECPGdebug(1,stderr);
    { ECPGconnect(__LINE__, 0, db , usr , pas , "con1", 0); }
#line 23 "json.sqc"

    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "set search_path to biblioteka", ECPGt_EOIT, ECPGt_EORT);}
#line 24 "json.sqc"


    // kursor ksiazek danego czytelnika
    { ECPGprepare(__LINE__, NULL, 0, "query_1", "select distinct k.ksiazka_id from wypozyczenie w join wypozyczenie_ksiazki wk using (wypozyczenie_id) join ksiazka k using (ksiazka_id) where w.czytelnik_id = ?");}
#line 27 "json.sqc"

    /* declare book_cursor cursor for $1 */
#line 28 "json.sqc"


    // teraz tytuly ksiazek
    { ECPGprepare(__LINE__, NULL, 0, "query_2", "select k.tytul from ksiazka k where k.ksiazka_id = ?");}
#line 31 "json.sqc"


    // teraz imiona i nazwiska czytelnikow
    { ECPGprepare(__LINE__, NULL, 0, "query_3", "select distinct c.imie, c.nazwisko from wypozyczenie_ksiazki wk join ksiazka k using (ksiazka_id) join wypozyczenie w using (wypozyczenie_id) join czytelnik c using (czytelnik_id) where wk.ksiazka_id = ?");}
#line 34 "json.sqc"

    /* declare name_cursor cursor for $1 */
#line 35 "json.sqc"


    /* when end of result set reached, break out of while loop */
    /* exec sql whenever not found  break ; */
#line 38 "json.sqc"


    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "declare book_cursor cursor for $1", 
	ECPGt_char_variable,(ECPGprepared_statement(NULL, "query_1", __LINE__)),(long)1,(long)1,(1)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(id),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, ECPGt_EORT);}
#line 40 "json.sqc"
 // to id to z programu
    printf("[");
    while(1) {
      { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "fetch book_cursor", ECPGt_EOIT, 
	ECPGt_int,&(book_id),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);
#line 43 "json.sqc"

if (sqlca.sqlcode == ECPG_NOT_FOUND) break;}
#line 43 "json.sqc"
 // to z query
      printf("{");

      // mamy id, teraz trzeba znalezc tytul tej ksiazki
      { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_execute, "query_2", 
	ECPGt_int,&(book_id),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, 
	ECPGt_char,(book_title),(long)40,(long)1,(40)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);
#line 47 "json.sqc"

if (sqlca.sqlcode == ECPG_NOT_FOUND) break;}
#line 47 "json.sqc"

      printf("\"tytul\": \"%s\",", book_title);

      // teraz bedziemy loopowac po czytelnikach
      int reader_count = 0;
      printf("\"czytelnicy\": [");
      { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "declare name_cursor cursor for $1", 
	ECPGt_char_variable,(ECPGprepared_statement(NULL, "query_3", __LINE__)),(long)1,(long)1,(1)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(book_id),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, ECPGt_EORT);}
#line 53 "json.sqc"

      while(1) {
          { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "fetch name_cursor", ECPGt_EOIT, 
	ECPGt_char,(fname),(long)40,(long)1,(40)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(lname),(long)40,(long)1,(40)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);
#line 55 "json.sqc"

if (sqlca.sqlcode == ECPG_NOT_FOUND) break;}
#line 55 "json.sqc"

          printf("{");
          reader_count++;
          printf("\"imie\": \"%s\", \"nazwisko\": \"%s\"", fname, lname);
          printf("},");
      }
      printf("],");
      printf("\"ilosc_czytelnikow\": %d", reader_count);
      { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "close name_cursor", ECPGt_EOIT, ECPGt_EORT);}
#line 63 "json.sqc"

      printf("},");
    }
    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "close book_cursor", ECPGt_EOIT, ECPGt_EORT);}
#line 66 "json.sqc"

    printf("]");

  return 0;
}