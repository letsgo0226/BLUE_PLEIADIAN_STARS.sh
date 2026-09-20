FROM python:3.12-alpine
WORKDIR /app
COPY PRIME_INDEX_HOLOGRAM_TM.sh /app/
COPY PRIME_INDEX_HOLOGRAM_RESIDENT.sh /app/
COPY deployment/prime_index_hologram/healthcheck.py /app/
RUN chmod +x /app/*.sh /app/healthcheck.py
ENV DATA_DIR=/data INTERVAL=1
VOLUME ["/data"]
HEALTHCHECK --interval=10s --timeout=5s --start-period=3s --retries=3 CMD ["python3","/app/healthcheck.py","/data/state.json"]
CMD ["/app/PRIME_INDEX_HOLOGRAM_RESIDENT.sh"]
