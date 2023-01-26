# Ustawiam dokładną wersję obrazu bazowego łącznie z SHA256, żeby mieć 100% pewności, że obraz nie został zmieniony "po cichu".
FROM node:18.13.0-bullseye-slim@sha256:bc946484118735406562f17c57ddf5fded436e175b6a51f827aa6540ba1e13de as development

# Instaluje pnpm, bo w tym projekcie korzystam z tego narzędzia do zarządzania zależnościami i skryptami.
RUN npm install -g pnpm

# Instaluje zależności niezbędne w czasie developmentu.
RUN apt-get update && apt-get install -y zsh curl neovim git

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Zmieniam domyślną powłokę na zsh.
RUN chsh -s $(which zsh)

FROM development as builder

# Instaluje program działający jako init system stworzony do tego, żeby działać z PID=1.
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init

# Najpierw kopiuje pliki konfiguracyjne, bo teoretycznie one rzadziej się zmieniają, niż kod źródłowy.
# W przypadku częstego budowania obrazu lokalnie w celach testowych będzie się to działo szybciej.
COPY package.json pnpm-lock.yaml esbuild.mjs tsconfig.json tsconfig.build.json /home/node/

# Instalacja zależności niezbędnych do zbudowania projektu.
RUN pnpm install --frozen-lockfile --ignore-scripts

COPY ./src/ /home/node/src/

RUN pnpm build

FROM node:18.13.0-bullseye-slim@sha256:bc946484118735406562f17c57ddf5fded436e175b6a51f827aa6540ba1e13de as production

# Ustawiam użytkownika innego, niż root, żeby w razie potencjalnego przejęcia kontroli nad kontenerem przez atakującego proces miał jak najmniejsze pozwolenia.
USER node

# Do obrazu produkcyjnego kopiuje tylko pliki absolutnie niezbędne do uruchomienia aplikacji.
# W tym kroku pliki muszą być skopiowane tak, żeby należały do użytkownika node.
COPY --from=builder --chown=node:node /home/node/dist/main.js /home/node/main.js
COPY --from=builder --chown=node:node /usr/bin/dumb-init /usr/bin/dumb-init

# Proces uruchamiam przy pomocy narzędzia dumb-init.
# Kod źródłowy muszę uruchomić przy pomocy node, a nie np. npm, bo npm nie przekazuje poprawnie wszystkich sygnałów systemowych (np. SIGHUP).
CMD ["dumb-init", "node", "/home/node/main.js"]
