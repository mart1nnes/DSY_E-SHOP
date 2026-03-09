\# E-shop s elektronikou – databázový projekt



\## Popis projektu



Tento projekt predstavuje návrh a implementáciu databázového systému pre jednoduchý e-shop s elektronikou.

Systém umožňuje evidenciu produktov, ich typov, značiek, modelov, registrovaných používateľov a nákupného košíka.



Databáza je implementovaná v systéme \*\*Microsoft SQL Server\*\* a je prepojená s jednoduchou webovou aplikáciou.



---



\## Funkcionalita systému



Systém umožňuje:



\* evidenciu rôznych typov elektroniky

\* evidenciu produktov a ich množstva na sklade

\* evidenciu značiek a modelov produktov

\* registráciu používateľov

\* evidenciu nákupného košíka

\* pridanie a odstránenie produktu z košíka

\* pridanie a zmazanie produktu z databázy

\* vyhľadávanie produktov podľa typu

\* vyhľadávanie produktov podľa ceny



---



\## Databázový model



Databáza obsahuje tieto tabuľky:



\* Typy\_produktov

\* Znacky

\* Modelove\_serie

\* Modely

\* Produkty

\* Pouzivatelia

\* Kosik

\* Polozky\_kosika



Vzťahy medzi tabuľkami:



\* Typy\_produktov → Produkty (1:N)

\* Znacky → Modelove\_serie (1:N)

\* Modelove\_serie → Modely (1:N)

\* Pouzivatelia → Kosik (1:N)

\* Kosik ↔ Produkty (M:N cez Polozky\_kosika)



---



\## Použité technológie



\* Microsoft SQL Server

\* Node.js

\* Express.js

\* HTML

\* JavaScript



---



\## Spustenie projektu



1\. Vytvorte databázu pomocou SQL skriptu.

2\. Spustite backend server:



```

node server.js

```



3\. Otvorte súbor `index.html` v prehliadači.



---



\## Autor



Projekt bol vytvorený ako školská práca pre predmet databázové systémy.



