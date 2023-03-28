FROM debian:bullseye

# cf:
# https://universaldependencies.org/
# https://towardsdatascience.com/named-entity-recognition-with-spacy-and-the-mighty-roberta-97d879f981
# https://blog.vsoftconsulting.com/blog/understanding-named-entity-recognition-pre-trained-models
# https://github.com/explosion/spacy-models/releases
# https://github.com/nikitakit/self-attentive-parser
#

RUN apt  update
RUN apt  install -y python3-pip bash-completion wget nodejs npm
RUN pip3 install torch torchvision torchaudio
RUN pip3 install jupyterlab ipywidgets jupyterlab-git     allennlp allennlp-models spacy pandas plotly spacy-experimental q
# spacy-experimental coreference cf. https://github.com/explosion/spacy-experimental/releases
RUN pip3 install  https://github.com/explosion/spacy-experimental/releases/download/v0.6.1/en_coreference_web_trf-3.4.0a2-py3-none-any.whl

# supports plotly(>=5) output in jupyterlab(>=3)
RUN pip3 install jupyterlab_widgets

RUN python3 -m spacy download      en_core_web_sm ; python3 -m spacy download en_core_web_lg ;
# RUN python3 -m spacy download    en_core_web_trf; \
#     python3 -m spacy download    en_core_web_sm ; \
#     python3 -m spacy download    en_core_web_md ; \
#     python3 -m spacy download    en_core_web_lg ;
#     python3 -m spacy download    ja_core_news_lg ; python3 -m spacy download    ja_core_news_trf ;

RUN ( mkdir -p /opt/models; \
      cd /opt/models; \
        wget --progress=bar:force https://storage.googleapis.com/allennlp-public-models/openie-model.2020.03.26.tar.gz ;\
        wget --progress=bar:force https://storage.googleapis.com/allennlp-public-models/structured-prediction-srl-bert.2020.12.15.tar.gz ;\
        wget --progress=bar:force https://storage.googleapis.com/allennlp-public-models/decomposable-attention-elmo-2020.04.09.tar.gz ;\
    )

# https://github.com/allenai/allennlp/blob/main/Makefile download-extra
#RUN python3 -c 'import nltk; [ nltk.download(p) for p in ("wordnet", "wordnet_ic", "sentiwordnet", "omw", "omw-1.4", "punkt") ]'

# for heideltime, resolving MM-DD to YYYY-MM-DD
#RUN apt install -y openjdk-11-jre ; \
#   pip3 install git+https://github.com/JMendes1995/py_heideltime.git; \
#   chmod a+rx /usr/local/lib/python3.9/dist-packages/py_heideltime/Heideltime/TreeTaggerLinux/bin/*

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
