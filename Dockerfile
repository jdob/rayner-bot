FROM ruby:2.5

ENV HOME=/code
RUN mkdir -p ${HOME} && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
            -c "Rayner Bot" default

WORKDIR ${HOME}

ADD bot.rb ${HOME}

RUN chown -R 1001:0 ${HOME} && \
    find ${HOME} -type d -exec chmod g+ws {} \;

USER 1001
CMD ["ruby", "bot.rb"]
