import warnings
warnings.filterwarnings('ignore', category=DeprecationWarning)
import time
import os
from dotenv import load_dotenv
from openai import OpenAI, OpenAIError
import streamlit as st
def main():
    load_dotenv()
    st.title('고객 지원 챗봇')
    # st.text(os.getenv('OPENAI_API_KEY'))
    # client 생성
    client = OpenAI()
    # 1. assistant 생성
    if 'assistant_id' not in st.session_state:
        assistant = client.beta.assistants.create(
            name='CustomerCSBot',
            instructions='당신은 고객 지원 챗봇입니다. 사용자 문의에 간략히 대답해 주세요',
            model='gpt-4o-mini'
        )
        st.session_state.assistant_id = assistant.id
    # 2. thread 초기화(각각 id를 session에 추가)
    if 'thread_id' not in st.session_state:
        thread = client.beta.threads.create()
        st.session_state.thread_id = thread.id
    # 대화 이력 초기화
    if 'messages' not in st.session_state:
        st.session_state.messages = []
    # 대화 이력 표시(system message는 제외)
    for msg in st.session_state.messages:
        st.chat_message(msg.get('role')).write(msg.get('content'))
    # 사용자 입력 받기
    if prompt := st.chat_input('메시지를 입력하세요'):
        prompt = prompt.strip()
        # 사용자 메시지를 session과 thread에 추가, 화면 출력
        st.session_state.messages.append({'role':'user', 'content':prompt})
        st.chat_message('user').write(prompt)
        # 3. 사용자 메시지를 thread에 추가
        client.beta.threads.messages.create(
            thread_id=st.session_state.thread_id,
            role='user',
            content=prompt
        )
        # 4. run 실행(답변 요청) - 과금
        client.beta.threads.runs.create_and_poll(
            thread_id=st.session_state.thread_id,
            assistant_id=st.session_state.assistant_id
        )
        # 5. 최신 답변 가져오기
        messages = client.beta.threads.messages.list(thread_id=st.session_state.thread_id)
        reply = messages.data[0].content[0].text.value # 최신 답변
        # 답변을 session에 추가하고 화면 출력
        st.session_state.messages.append({'role':'assistant', 'content':reply})
        st.chat_message('assistant').write(reply)
    # 6. 대화 이력 백업
    if st.button('대화 이력 백업'):
        # thread에서 전체 메시지 list로 가져오기
        messages = client.beta.threads.messages.list(thread_id=st.session_state.thread_id)
        if messages:
            # 시간 순서대로 정렬한 후 파일 백업
            sorted_messages = sorted(messages.data,
                        key=lambda msg : msg.created_at)
            with open('data/ch7_history.txt', 'w', encoding='utf-8') as f:
                for msg in sorted_messages:
                    # role / content / dateStr
                    content = msg.content[0].text.value
                    role = msg.role
                    dateStr = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(msg.created_at))   
                    # 파일 기록
                    row = '{:9}({}) : {}\n'.format(role, dateStr, content)
                    f.write(row)
                st.info('대화 이력을 백업하였습니다')
        else:
            st.error('대화 이력이 없습니다')        
    st.caption('대화 수 : {}'.format(len(st.session_state.messages)))



if __name__ == '__main__':
    main()