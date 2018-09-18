FROM python:3

ENV HOME=/code
RUN mkdir -p ${HOME} && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
            -c "Rayner Application User" default
WORKDIR ${HOME}

ADD rayner_bot ${HOME}/rayner_bot
ADD requirements.txt setup.py ${HOME}/

RUN pip install -r requirements.txt -e .

RUN chown -R 1001:0 ${HOME} && \
    find ${HOME} -type d -exec chmod g+ws {} \;

USER 1001
CMD ["python", "rayner_bot/runner.py"]
