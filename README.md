Ukol 1

- ASP.Net webforms app, validace vstupniho pole ... Je nutne vytvorit na mssql db 'test_sx_pon', pustit nad ni ~/App_Data/setup.sql a nastavit si odpovidajici connection string ve ~/web.config ... Po dotazeni packages staci jen spustit.

- V zadani neni specifikovane zadne omezeni, takze cestou nejmensiho odporu je pouzity 4.7.2 framework, dapper a defaultni unobtrusive validation doplneny o custom validator s klientskou a serverovou validaci. Jsou pouzite defaultni RequiredFieldValidator, RegularExpressionValidator a standardni CustomValidator s klientskou a serverovou kontrolou na existenci mailu.

- CustomValidator si na pozadi overuje existenci emailu v databazi a po obdrzeni odpovedi zpusobi ReValidaci formulare (evt. fieldu). Jednodussi reseni pomoci synchronniho ajax dotazu jsem preskocil, protoze takovy request je blokujici a zasekne UI po dobu overovani, pricemz klientske validatory potrebuji vysledek v dobe validace.

- Oproti defaultnimu chovani validatoru je umozneno zadat/pastnout email s mezerou na konci, coz se uzivatelum deje relativne casto, pro potreby ulozeni a kontroly se vstup trimuje. V ramci prototypu neni resena zpetna kompatibilita s obskurnimi verzemi prohlizecu.

- Po relativne drobnych zasazich by z toho sel udelat reusable input i s nejakym activity indikatorem, vicemene by slo o nahradu ValidatorValidate za Page_ClientValidate, nejake vetsi testovani s ValidationSummary a par detailu.

- Spousteni validace po 500 ms od ukonceni psani je tu z duvodu, kdy uzivatel nemusi opustit input field, na to aby stiskl tlacitko Next. Zbytecne neprodluzujeme cekani na overeni az ve fazi odesilani. Princip by ale byl obdobny - odlozit postback a pockat na vysledek async validace. Pro pripad spatneho spojeni ci timeoutu takoveho overeni je ale uprednostneno odeslani formulare i s pripadne nezkontrolovanym emailem. Ve finale by byl zachycen jeste serverovou validaci.

- [DEBUG] radek na strance zobrazuje, kdy doslo k reloadu stranky, pokud by k tomu melo dojit (napr. race mezi validaci a insertem) a take vypise pocet zaznamu v databazi.
