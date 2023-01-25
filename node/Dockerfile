FROM node:18.13.0-bullseye-slim@sha256:bc946484118735406562f17c57ddf5fded436e175b6a51f827aa6540ba1e13de as development

# Zmieniam domyślną strefę czasową, żeby daty były formatowane zgodnie z moją strefą czasową.
ENV TZ="Europe/Warsaw"

# Instaluje pnpm. Nie dodaję do do cache, żeby nie zajmował dodatkowego miejsca.
RUN npm install -g pnpm

# Instaluje zależności niezbędne w czasie developmentu.
RUN apt-get update && \
    apt-get install zsh curl neovim

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Zmieniam domyślną powłokę na zsh.
RUN chsh -s $(which zsh)

# Uruchamiając kontener chciałbym domyślnie uruchomić zsh.
CMD ["zsh"]

FROM development as builder

FROM base as production
