# Obraz bazowy

Wybór odpowiedniego obrazu bazowego jest ważny z następujących powodów:

- W czasie developmentu chce mieć łatwy dostęp do popularnych programów (np. `curl`, `git`, `apt-get`, `bash`).
- W czasie uruchamiania kontenera na produkcji chce, żeby obraz zawierał jak najmniej zbędnych zależności, bo każdy
  zbędny program to potencjalne ryzyko związane z bezpieczeństwem.
- W czasie wypychania obrazu do docker registry chce, żeby obraz ważył jak najmniej, żeby zmniejszyć zużycie
  przepustowości łącza.
- W czasie przechowywania obrazu w docker registry chce, żeby obraz ważył jak najmniej, żeby zmniejszyć zużycie miejsca
  na dysku.

# Alpine

Obrazy bazowe `alpine` mają najmniej zależności, więc są najlżejsze oraz mają najmniej problemów z bezpieczeństwem. Nie
są to oficjalnie wspierane obrazy, więc czasami mogą być z
nimi [problemy](https://snyk.io/blog/choosing-the-best-node-js-docker-image/).

# Buster, bullseye, stretch

Obrazy bazowe takie jak `buster`, `bullseye`, czy `stretch` odnoszą się do wersji systemu operacyjnego `debian`.
Aktualnie wersją LTS jest wersja `bullseye`, więc tylko z niej powinienem korzystać. Inne wersje to wersje poprzednie i
nie powinienem z nich korzystać. Obrazy te mają również swoje wersje `*-slim`, które mają mniej zależności.

Domyślnie chciałbym korzystać z obrazu `bullseye-slim`, ponieważ:

- Jest to obraz oficjalnie wspierany przez docker Node.js team.
- Nie wykorzystuje większości programów z obrazu pełnego. Brakujące programy mogę łatwo zainstalować.

# Obrazy distroless

Google ma projekt obrazów `distroless`, które zawierają absolutne minimum wymagane do uruchomienia aplikacji.
Przykładowo, nie ma w nich menedżera pakietów, czy shell. Dzięki temu ich rozmiar oraz podatności związane z
bezpieczeństwem są jeszcze mniejsze, niż w przypadku obrazów typu alpine, ale praca z nimi jest trudniejsza, ponieważ
wymaga specjalnego podejścia.

# dumb-init

`dumb-init` to program, który został stworzony z myślą o tym, żeby uruchamiać go jako `init process`. `Init process` to
proces, który jest uruchamiany z `PID=1` i jest traktowany w specjalny sposób przez linux kernel.

Node.js nie został zaprojektowany z myślą o byciu uruchomionym z `PID=1`, więc niektóre sygnały systemowe nie będę
poprawnie
obsługiwane. [Tutaj](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md#handling-kernel-signals) jest
szczegółowe wyjaśnienie problemu. Rozwiązaniem problemu jest implementacja tzw. `init system`, czyli uruchomienie
programu specjalnie zaprojektowanego do posiadania `PID=1`.

# Źródła

- [Choosing the best Node.js Docker image.](https://snyk.io/blog/choosing-the-best-node-js-docker-image/)
- [Docker for Node.js developers: 5 things you need to know not to fail your security.](https://snyk.io/blog/docker-for-node-js-developers-5-things-you-need-to-know/)
- [10 best practices to containerize Node.js web applications with Docker.](https://snyk.io/blog/10-best-practices-to-containerize-nodejs-web-applications-with-docker/)
- [Alpine, Slim, Stretch, Buster, Jessie, Bullseye — What are the Differences in Docker Images?](https://medium.com/swlh/alpine-slim-stretch-buster-jessie-bullseye-bookworm-what-are-the-differences-in-docker-62171ed4531d)
- [Docker and Node.js Best Practices.](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)
