import logging

DEFAULT_LOGGING_LEVEL = logging.ERROR
# DEFAULT_LOGGING_LEVEL = logging.DEBUG

loggerPool = {}

def createLogger(fileName):
    # create logger

    # TODO: Find out how we can disable this in unit testing
    # logging.addLevelName( logging.WARNING, "\033[1;31m%s\033[1;0m" % logging.getLevelName(logging.WARNING))
    # logging.addLevelName( logging.ERROR, "\033[1;41m%s\033[1;0m" % logging.getLevelName(logging.ERROR))

    logger = logging.getLogger(fileName)
    logger.setLevel(DEFAULT_LOGGING_LEVEL)

    # create console handler and set level
    ch = logging.StreamHandler()
    ch.setLevel(DEFAULT_LOGGING_LEVEL)

    # create formatter
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

    # add formatter to ch
    ch.setFormatter(formatter)

    # add ch to logger
    logger.addHandler(ch)

    loggerPool[fileName] = loggerPool

    return logger