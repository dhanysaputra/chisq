import sys

best={}
while 1:
	try:
		line=sys.stdin.readline()
	except KeyboardInterrupt:
		break
	if not line:
		break
	best[line.split('\t')[0]+'\t'+line.split('\t')[1]]=''
for line in file(sys.argv[1], 'rU').readlines():
	if line.startswith('#'):
		print line,
	else:
		if line.split('\t')[0]+'\t'+line.split('\t')[1] in best.keys():
			print line,