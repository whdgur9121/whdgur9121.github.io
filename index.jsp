<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.jsoup.Jsoup" %>
<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 크롤링할 URL
    String url1 = "https://www.inha.ac.kr/kr/950/subview.do";
    String url2 = "https://newdept.inha.ac.kr/act/2970/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGYWN0JTJGNzE2JTJGYXJ0Y2xMaXN0LmRvJTNG";
    String url3 = "https://cse.inha.ac.kr/cse/888/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGY3NlJTJGMjQyJTJGYXJ0Y2xMaXN0LmRvJTNG";

    Document doc1 = Jsoup.connect(url1).get();
    Document doc2 = Jsoup.connect(url2).get();
    Document doc3 = Jsoup.connect(url3).get();

    // 크롤링 결과 확인
    Elements notices1 = doc1.select("table tbody tr");
    Elements notices2 = doc2.select("table tbody tr");
    Elements notices3 = doc3.select("table tbody tr");

    // 현재 날짜 및 시간
    Date now = new Date();
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy년 MM월 dd일 E요일 HH:mm:ss");
    String currentTime = dateFormat.format(now);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>인하대학교 공지사항</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: black;
        }
        .title {
            font-size: 40px;
            font-weight: bold;
            text-align: left;
            color: white;
        }
        .subtitle {
            font-size: 20px;
            color: #D6D6D6;
        }
        .table-container {
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            background-color: #f2f2f2;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        thead {
            background-color: #C6C4C4;
            border: 2px solid black;
        }
        .t1{
        	width: 5%;
        }
        .t2{
        	width: 85%;
        }
        caption {
            font-size: 20px;
            caption-side: top;
            text-align: left;
            font-weight: bold;
            margin-bottom: 10px;
            color: white;
        }
        .tbcaption {
            text-decoration: none;
            color: #D6D6D6;
        }
        a {
            text-decoration: none;
            color: black;
        }
        a:hover {
            color: blue;
        }
        .reset-button {
            background-color: #B0AFAF;
            color: black;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        .reset-button:hover {
            background-color: white;
        }
    </style>
    <script>
        // 공지사항 클릭 시 로컬 스토리지에 저장
        function handleNoticeClick(title, link, date) {
            console.log(`Clicked: ${title}, ${link}, ${date}`); // 디버깅을 위해 로그 추가
            const clickedNotices = JSON.parse(localStorage.getItem('clickedNotices')) || [];
            clickedNotices.push({ title, link, date });
            localStorage.setItem('clickedNotices', JSON.stringify(clickedNotices));
            displayClickedNotices();
        }

        // 로컬 스토리지에 저장된 공지사항 표시
        function displayClickedNotices() {
            const clickedNotices = JSON.parse(localStorage.getItem('clickedNotices')) || [];
            const tbody = document.getElementById('clicked-notices-tbody');
            tbody.innerHTML = ''; // 초기화

            clickedNotices.forEach((notice, index) => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${index + 1}</td>
                    <td><a href="${notice.link}" target="_blank">${notice.title}</a></td>
                    <td>${notice.date}</td>
                `;
                tbody.appendChild(tr);
            });
        }

        // 로컬 스토리지 초기화
        function resetClickedNotices() {
            localStorage.removeItem('clickedNotices');
            displayClickedNotices();
        }

        // 페이지 로드 시 클릭한 공지사항 표시
        window.onload = function() {
            displayClickedNotices();
        }
    </script>
</head>
<body>
    <div class="title">인하대학교 공지사항</div>
    <div class="subtitle">오늘은 <%= currentTime %>입니다.</div>

    <div class="table-container">
        <table>
            <caption>인하대학교 홈페이지 공지사항 <a class="tbcaption" href="<%= url1 %>">(바로가기)</a></caption>
            <thead>
                <tr>
                    <th class="t1">index</th>
                    <th class="t2">제목(클릭시 해당 공지사항 이동)</th>
                    <th class="t3">날짜</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int index = 1;
                    for (Element notice : notices1) {
                        if (index > 10) {
                            break; // 10개의 공지만 가져오기 위해 루프 종료
                        }

                        Elements tds = notice.select("td");
                        String title = tds.get(1).text();
                        String link = "https://www.inha.ac.kr" + tds.get(1).select("a").attr("href");
                        String date = tds.get(3).text();

                        // "첨부파일이 있음" 제거
                        title = title.replace("첨부파일이 1 개 있음", "").trim();
                        title = title.replace("첨부파일이 1개 있음", "").trim();
                        title = title.replace("첨부파일이 2개 있음", "").trim();
                        title = title.replace("첨부파일이 3개 있음", "").trim();
                        title = title.replace("새글", "").trim();
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><a href="<%= link %>" target="_blank" onclick="handleNoticeClick('<%= title %>', '<%= link %>', '<%= date %>')"><%= title %></a></td>
                    <td><%= date %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="table-container">
        <table>
            <caption>인하대학교 소프트웨어 융합대학 공지사항 <a class="tbcaption" href="<%= url2 %>">(바로가기)</a></caption>
            <thead>
                <tr>
                    <th class="t1">index</th>
                    <th class="t2">제목(클릭시 해당 공지사항 이동)</th>
                    <th class="t3">날짜</th>
                </tr>
            </thead>
            <tbody>
                <%
                    index = 1;
                    for (Element notice : notices2) {
                        if (index > 10) {
                            break; // 10개의 공지만 가져오기 위해 루프 종료
                        }

                        Elements tds = notice.select("td");
                        String title = tds.get(1).text();
                        String link = "https://newdept.inha.ac.kr" + tds.get(1).select("a").attr("href");
                        String date = tds.get(3).text();

                        // "첨부파일이 있음" 제거
                        title = title.replace("첨부파일이 1 개 있음", "").trim();
                        title = title.replace("첨부파일이 2개 있음", "").trim();
                        title = title.replace("첨부파일이 3개 있음", "").trim();
                        title = title.replace("새글", "").trim();
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><a href="<%= link %>" target="_blank" onclick="handleNoticeClick('<%= title %>', '<%= link %>', '<%= date %>')"><%= title %></a></td>
                    <td><%= date %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="table-container">
        <table>
            <caption>인하대학교 컴퓨터공학과 공지사항 <a class="tbcaption" href="<%= url3 %>">(바로가기)</a></caption>
            <thead>
                <tr>
                    <th class="t1">index</th>
                    <th class="t2">제목(클릭시 해당 공지사항 이동)</th>
                    <th class="t3">날짜</th>
                </tr>
            </thead>
            <tbody>
                <%
                    index = 1;
                    for (Element notice : notices3) {
                        if (index > 10) {
                            break; // 10개의 공지만 가져오기 위해 루프 종료
                        }

                        Elements tds = notice.select("td");
                        String title = tds.get(1).text();
                        String link = "https://cse.inha.ac.kr" + tds.get(1).select("a").attr("href");
                        String date = tds.get(3).text();

                        // "첨부파일이 있음" 제거
                        title = title.replace("첨부파일이 1 개 있음", "").trim();
                        title = title.replace("첨부파일이 2개 있음", "").trim();
                        title = title.replace("첨부파일이 3개 있음", "").trim();
                        title = title.replace("새글", "").trim();
                %>
                <tr>
                    <td><%= index++ %></td>
                    <td><a href="<%= link %>" target="_blank" onclick="handleNoticeClick('<%= title %>', '<%= link %>', '<%= date %>')"><%= title %></a></td>
                    <td><%= date %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div>
        <table>
            <thead>
                <tr><th>주요 사이트(클릭시 해당 사이트 이동)</th></tr>
            </thead>
            <tbody>
                <tr>
                    <td><a href="https://learn.inha.ac.kr/login.php?errorcode=4">인하대학교 아이클래스</a></td>
                </tr>
                <tr>
                    <td><a href="https://portal.inha.ac.kr/login.jsp?idpchked=false">인하대학교 포털</a></td>
                </tr>
                <tr>
                    <td><a href="https://sugang.inha.ac.kr/sugang/">인하대학교 수강신청</a></td>
                </tr>
                <tr>
                    <td><a href="https://www.inha.ac.kr/kr/index.do">인하대학교 홈페이지</a></td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="table-container">
        <table>
            <caption>확인한 공지사항 기록</caption>
            <thead>
                <tr>
                    <th class="t1">index</th>
                    <th class="t2">제목(클릭시 해당 공지사항 이동)</th>
                    <th class="t3">날짜</th>
                </tr>
            </thead>
            <tbody id="clicked-notices-tbody">
                <!-- JavaScript로 클릭한 공지사항 표시 -->
            </tbody>
        </table>
                <button class="reset-button" onclick="resetClickedNotices()">기록 초기화</button>
    </div>
</body>
</html>