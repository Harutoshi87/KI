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