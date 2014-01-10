from scipy.stats import chisqprob
import sys

while 1:
        try:
                line=sys.stdin.readline()
        except KeyboardInterrupt:
                break
        if not line:
                break
        if not 'NaN' in line:
                print str(chisqprob(float(line.split('\t')[0]),1))+'\t'+line.split('\t')[0]+'\t'+line.split('\t')[1],