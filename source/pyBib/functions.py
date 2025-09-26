def safe_index(lst, item, start=0):
    '''
    첫번째 매개변수 lst : 리스트, 튜플
    두번째 매개변수 item : 리스트나 튜플에서 찾을 데이터
    세번째 매개변수 start : 몇 번째 index부터 찾을지 index 수(기본값:0)
    '''
    return lst.index(item, start) if item in lst[start:] else '데이터가 없습니다'

def safe_remove(lst, item):
    '''
    첫번째 매개변수 lst :  리스트, 셋
    두번째 매개변수 item : 리스트나 셋에서 삭제할 데이터
    '''
    if item in lst:
        lst.remove(item)
    else:
        print('삭제할 데이터가 없습니다')

def lst_safe_pop(lst, index=-1):
    '''
    첫번째 매개변수 lst :  리스트
    두번째 매개변수 index : 리스트에서 삭제할 데이터의 index 수 (기본값:-1)
    '''
    if index in lst:
        return lst.pop(index)
    else:
        print('pop할 데이터가 없습니다')
        
def dic_safe_pop(dic, key):
    '''
    첫번째 매개변수 dic : 딕셔너리
    두번째 매개변수 key : 딕셔너리에서 삭제할 key
    '''
    return dic.pop(key) if key in dic else 'pop할 key가 없습니다'