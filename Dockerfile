FROM avikdatta/basejupyterdockerimage

MAINTAINER reach4avik@yahoo.com

ENTRYPOINT []

ENV NB_USER vmuser

USER root
WORKDIR /root/

RUN apt-get -y update &&   \
    apt-get install --no-install-recommends -y   \
    tk-dev                 \
    gfortran               \
    sqlite3                \
    &&  apt-get purge -y --auto-remove \
    &&  apt-get clean \
    &&  rm -rf /var/lib/apt/lists/*
    
USER $NB_USER
WORKDIR /home/$NB_USER

ENV PYENV_ROOT /home/$NB_USER/.pyenv
ENV PATH "$PYENV_ROOT/libexec/:$PATH" 
ENV PATH "$PYENV_ROOT/shims/:$PATH"

RUN eval "$(pyenv init -)" 
RUN pyenv global 3.5.2

RUN pip install    \
        --no-cache-dir -q \
        cython     \
        numpy      \
        scipy      \
        sklearn    \
        pandas     \
        matplotlib \
        seaborn    \
        pandas_datareader  \
        bs4        \
        matplotlib \
        nltk       \
        gensim     \
        pymysql    \
        xlrd       \
        openpyxl   \
        sqlalchemy \
        slackclient \
        asana       \
        holoviews   \
        bokeh       \
        line_profiler \
        memory_profiler \
        plotly       \
        cufflinks

RUN set -ex; \
    rm -rf /home/$NB_USER/.cache; \
    find $PYENV_ROOT -type d -a \( -name test -o -name tests \) -exec rm -rf '{}' +; \
    find $PYENV_ROOT -type f -a \( -name '*.pyc' -o -name '*.pyo' \) -exec rm -f '{}' +; \
    rm -rf /home/$NB_USER/tmp; \
    mkdir /home/$NB_USER/tmp
    
EXPOSE 8888
CMD ["jupyter","lab","--ip=0.0.0.0","--port=8888","--no-browser","--NotebookApp.iopub_data_rate_limit=100000000"]
