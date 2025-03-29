FROM jenkins/inbound-agent
USER root
RUN apt update && apt install php -y
RUN apt-get install -y php libapache2-mod-php php-mysql php-mbstring php-xml php-curl php-gd zip unzip
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

RUN curl -L -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
RUN unzip sonar-scanner-cli-5.0.1.3006-linux.zip
RUN mkdir sonar-scanner
RUN cd sonar-scanner-5.0.1.3006-linux && mv bin conf jre lib ../sonar-scanner
RUN rm sonar-scanner-cli-5.0.1.3006-linux.zip
RUN rmdir sonar-scanner-5.0.1.3006-linux
ENV PATH="$PATH:/home/jenkins/sonar-scanner/bin/"