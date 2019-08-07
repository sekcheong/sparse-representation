function [img] = dict2image(D, blockSize, dictSize)
    img = showdict(D,[1 1]*blockSize, round(sqrt(dictSize)), round(sqrt(dictSize)), 'lines', 'highcontrast');