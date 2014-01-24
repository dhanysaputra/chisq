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
		print line.split('\n')[0]+'\t'+str(chisqprob(float(line.split('\t')[11]),1))