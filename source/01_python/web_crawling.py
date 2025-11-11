def get_image_list_1(query):
    'query로 검색한 이미지 정보(정보,링크,썸네일,크기) 100건 데이터 프레임을 return(방법1)'
    import requests
    import json
    import pandas as pd
    from dotenv import load_dotenv
    import os
    load_dotenv()
    client_id = os.getenv('CLIENT_ID')
    client_secret = os.getenv('CLIENT_SECRET')
    url = 'https://openapi.naver.com/v1/search/image'
    params = {'query':query, 'display':100 }
    headers = {
        'X-Naver-Client-Id':client_id,
        'X-Naver-Client-Secret':client_secret
    }
    response = requests.get(url, params=params, headers=headers)
    #items = response.json()['items']
    items = json.loads(response.text)['items']
    #print(items[0])
    items_list = []
    for item in items:
        #print(item)
        link = item.get('link')
        thumbnail = item.get('thumbnail')
        items_list.append({
            '제목':item.get('title'),
            '링크':link,
            '썸네일': thumbnail,
            'sizeheight': int(item.get('sizeheight')),
            'sizewidth':  int(item.get('sizewidth')),
        })
    return pd.DataFrame(items_list)
df = get_image_list_1("청바지")
df.to_csv('data/ch14_청바지.csv')
df.sample()

def get_image_list_2 (query):
    'query로 검색한 이미지 정보(정보,링크,썸네일,크기) 100건 데이터 프레임을 return(방법2)'
    from urllib.request import urlopen, Request
    from urllib.parse import quote
    import json
    import pandas as pd
    from dotenv import load_dotenv
    import os
    load_dotenv()
    client_id = os.getenv('CLIENT_ID')
    client_secret = os.getenv('CLIENT_SECRET')
    encText = quote(query)
    url = f'https://openapi.naver.com/v1/search/image?query={encText}&display=100'
    headers = {
        'X-Naver-Client-Id':client_id,
        'X-Naver-Client-Secret':client_secret
    }
    request = Request(url, headers=headers)
    response = urlopen(request)
    # print(response.read().decode('utf-8'))
    items = json.loads(response.read().decode('utf-8'))['items']
    items_list = []
    for item in items:
        #print(item)
        link = item.get('link')
        thumbnail = item.get('thumbnail')
        items_list.append({
            '제목':item.get('title'),
            '링크':link,
            '썸네일': thumbnail,
            'sizeheight': int(item.get('sizeheight')),
            'sizewidth':  int(item.get('sizewidth')),
        })
    return pd.DataFrame(items_list)
df = get_image_list_2("청바지")
df.to_csv('data/ch14_청바지.csv')
df.sample()

def save_image(attr, idx, link, query):
    'link의 이미지를 image/attr_idx_query.확장자로 local에 저장'
    file_extension = link.split('.')[-1] # 확장자
    img = requests.get(link).content # 바이너리
    with open(f'image/{attr}_{idx+1}_{query}.{file_extension}', 'wb' ) as f:
        f.write(img)
save_image('메인', 0, df.loc[77, '링크'], '청바지')