FROM debian:bullseye

# cf:
# https://universaldependencies.org/
# https://towardsdatascience.com/named-entity-recognition-with-spacy-and-the-mighty-roberta-97d879f981
# https://blog.vsoftconsulting.com/blog/understanding-named-entity-recognition-pre-trained-models
# https://github.com/explosion/spacy-models/releases
# https://github.com/nikitakit/self-attentive-parser
#

RUN apt  update
RUN apt  install -y python3-pip bash-completion python3-tk
RUN pip3 install jupyterlab ipywidgets benepar spacy nltk stanza pandas q
#RUN pip3 install spacy[transformers,lookups];

RUN python3 -m spacy download    en_core_web_trf; \
    python3 -m spacy download    en_core_web_sm ; \
    python3 -m spacy download    en_core_web_md ; \
    python3 -m spacy download    en_core_web_lg ;
#   python3 -m spacy download    ja_core_news_lg ; python3 -m spacy download    ja_core_news_trf ;

RUN python3 -c "import benepar; benepar.download('benepar_en3');"


ARG workdir=/work
ARG port=8888
ARG token=''

RUN mkdir -p ${workdir}
WORKDIR ${workdir}
VOLUME ${workdir}

ENV JUPYTER_PORT=${port}
ENV JUPYTER_TOKEN=${token}
ENV JUPYTER_ROOT=${workdir}
ENV SHELL=/bin/bash

CMD jupyter-lab --ip 0.0.0.0 --port ${JUPYTER_PORT} --allow-root --no-browser --notebook-dir=${JUPYTER_ROOT} --ServerApp.token=${JUPYTER_TOKEN}
