FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive \
    && sed -i 's,http://archive.ubuntu.com/ubuntu/,mirror://mirrors.ubuntu.com/mirrors.txt,' /etc/apt/sources.list \
    && apt-get update -qq && apt-get upgrade -qq \

    && apt-get install -y --no-install-recommends \
        nginx-light \
        libjpeg-dev \
        zlib1g-dev \
        libpng-dev \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-psycopg2 \

    && BUILD_DEPS='build-essential python3-dev' \
    && apt-get install -y --no-install-recommends ${BUILD_DEPS} \

    && pip3 install --no-cache-dir \
        circus==0.13.0 \
        gunicorn==19.5.0 \
        iowait==0.2 \
        psutil==4.2.0 \
        pyzmq==15.2.0 \
        tornado==4.3 \

    && apt-get autoremove -y ${BUILD_DEPS} \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY requirements.txt /opt/razvitie/app/
RUN pip3 install --no-cache-dir -r /opt/razvitie/app/requirements.txt

COPY etc/ /etc/
COPY razvitie/ /opt/razvitie/app/

WORKDIR /opt/razvitie/app
ENV STATIC_ROOT=/opt/razvitie/static
RUN nginx -t \
    && python3 -c 'import compileall, os; compileall.compile_dir(os.curdir, force=1)' > /dev/null \
    && ./manage.py collectstatic --settings=razvitie.settings --no-input -v0
CMD ["circusd", "/etc/circus/web.ini"]
