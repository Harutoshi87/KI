def fillna_gr_iris(series):
    'series의 결측치를 대체한 후 series return'
    # pd.options.mode.copy_on_write = True
    series = series.copy() # 함수 안에서 series의 결측치를 대체하여 변경하기 위해
    for col, item in series.iloc[:-1].items(): # col : 열
                                     # item : 값
                                     # series
                                     # items : series의 모든 값들
        if np.isnan(item): # 스칼라 데이터가 결측치인지 여부
            species = series['species']
            series[col] = iris_mean.loc[species, col] # 종별 열별 평균값 대체
    return series

def fillna_gr_penguins(series):
    'series의 결측치를 대체한 후 series return'
    # pd.options.mode.copy_on_write = True
    series = series.copy() # 함수 안에서 series의 결측치를 대체하여 변경하기 위해
    for col, item in series.iloc[2:-1].items(): # col : 열
                                     # item : 값
                                     # series
                                     # items : series의 모든 값들
        if np.isnan(item): # 스칼라 데이터가 결측치인지 여부
            species = series['species']
            series[col] = p_mean.loc[species, col] # 종별 열별 평균값 대체
    return series

def fillna_gr_diabetes(series):
    'series의 결측치를 대체한 후 series return'
    series = series.copy() # 함수 안에서 series의 결측치를 대체하여 변경하기 위해
    for col, item in series.iloc[:-1].items():
        if np.isnan(item): # 스칼라 데이터가 결측치인지 여부
            row=series['진행정도']
            series[col] = d_mean.loc[row, col] # 진행정도별 열별 평균값 대체
    return series

# 결측치->결측치 return, 공백문자->결측치 return, '3,198' -> 3198 return, '3198'->3198 return,  
def commadrop2(price):
    if pd.isna(price):
        return np.nan
    elif price.strip() == '':
        return np.nan
    elif price.find(',') !=-1:
        price_splited = price.split(',')
        return float(''.join(price_splited))
    else:
        return float(price)

commadrop2(df_last.loc[80, '분양가격(제곱미터)']) # 콤마제외한 문자를 숫자로 
commadrop2(df_last.loc[1, '분양가격(제곱미터)']) # 콤마없는 문자를 숫자로 
commadrop2(df_last.loc[28, '분양가격(제곱미터)']) # 공백문자를 nan
commadrop2(df_last.loc[368, '분양가격(제곱미터)']) # nan을 nan