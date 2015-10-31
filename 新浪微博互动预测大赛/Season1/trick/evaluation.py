__author__ = 'Desmond & wepon'
__date__ = "2015/08/14"

"""
evaluation function  accoding to official rule:
    http://tianchi.aliyun.com/competition/information.htm?spm=5176.100067.5678.2.Grh4pl&raceId=5
    
"""

def _deviation(predict, real, kind):
    t = 5.0 if kind=='f' else 3.0
    return abs(predict - real) / (real + t)


def _precision_i(fp, fr, cp, cr, lp, lr):
    return 1 - 0.5 * _deviation(fp, fr, 'f') - 0.25 * _deviation(cp, cr, 'c') - 0.25 * _deviation(lp, lr, 'l')


def _sgn(x):
    return 1 if x>0 else 0


def _count_i(fr, cr, lr):
    x = fr + cr + lr
    return 101 if x>100 else (x+1)


def precision(real_and_predict):
    numerator,denominator = 0.0,0.0
    for  fr, cr, lr,fp, cp, lp in real_and_predict:
        numerator += _count_i(fr, cr, lr) * _sgn(_precision_i(fp, fr, cp, cr, lp, lr) - 0.8)
        denominator += _count_i(fr, cr, lr)
    return numerator / denominator
