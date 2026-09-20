FROM python:3.12-alpine
WORKDIR /app
COPY RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh /app/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh
COPY deployment/riemann_log_product/resident_loop.sh /app/resident_loop.sh
COPY deployment/riemann_log_product/healthcheck.py /app/healthcheck.py
RUN chmod +x /app/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh /app/resident_loop.sh /app/healthcheck.py
ENV ROOT=/app DATA_DIR=/data INTERVAL=1
VOLUME ["/data"]
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 CMD ["python3","/app/healthcheck.py","/data/state.json"]
CMD ["/app/resident_loop.sh"]
