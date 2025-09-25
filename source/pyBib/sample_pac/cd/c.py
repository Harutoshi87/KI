#python sample_pac/cd/c.py
import sys
sys.path.append(r'C:\KI\source\pyBib')
from sample_pac.ab import a
# python -m sample_pac.cd.c
#from ..ab import a

def nice():
    print('sample_pac/cd/패키지 안의 c모듈 안의 nice')
    a.hello()

if __name__ == '__main__':
    nice()