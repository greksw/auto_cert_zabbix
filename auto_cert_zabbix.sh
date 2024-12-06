#!/bin/bash

# Параметры для самоподписного сертификата
COUNTRY="RU"
STATE="Moscow"
LOCALITY="Moscow"
ORGANIZATION="Zabbix"
ORG_UNIT="IT"
COMMON_NAME="192.168.2.30"

# Директории для сертификатов
CERT_DIR="/etc/ssl/certs/zabbix"
KEY_DIR="/etc/ssl/private"

# Создание директорий, если их нет
sudo mkdir -p "$CERT_DIR" "$KEY_DIR"

echo "Создаём самоподписной сертификат с параметрами:"
echo "Страна: $COUNTRY"
echo "Область: $STATE"
echo "Город: $LOCALITY"
echo "Организация: $ORGANIZATION"
echo "Отдел: $ORG_UNIT"
echo "Домен (или IP): $COMMON_NAME"

# Генерация сертификата и ключа
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$KEY_DIR/zabbix.key" \
    -out "$CERT_DIR/zabbix.crt" \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$COMMON_NAME"

# Установка прав доступа
sudo chmod 600 "$KEY_DIR/zabbix.key"
sudo chmod 644 "$CERT_DIR/zabbix.crt"

echo "Сертификат создан:"
echo " - Сертификат: $CERT_DIR/zabbix.crt"
echo " - Ключ: $KEY_DIR/zabbix.key"

# Перезапуск Nginx
echo "Перезапускаем Nginx..."
sudo systemctl restart nginx

# Проверка статуса Nginx
if systemctl is-active --quiet nginx; then
    echo "Nginx успешно перезапущен."
else
    echo "Ошибка при перезапуске Nginx. Проверьте конфигурацию."
    sudo systemctl status nginx
fi
