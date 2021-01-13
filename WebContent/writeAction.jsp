<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body> 
	<%
		String saveFolder = "shopimage";
		ServletContext scontext = getServletContext();
		String fileurl = scontext.getRealPath(saveFolder);
		String encType="utf-8";
		int Maxsize = 5*1024*1024;
	
		MultipartRequest multi = null;
		DefaultFileRenamePolicy policy = new DefaultFileRenamePolicy();
		multi = new MultipartRequest(request, fileurl, Maxsize, encType, policy);
		
		Enumeration<?> files = multi.getFileNames();
		String fname = (String) files.nextElement();
		String filename = multi.getFilesystemName(fname);
		String title = multi.getParameter("bbsTitle");
		String content = multi.getParameter("bbsContent");
	%>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null)
		{
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null){		// 로그인 안된 사람 로그인창으로 보내기
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}	
		else
		{
			if(title == null || content == null || filename == null)	// 글제목, 글내용 미작성시
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else
			{	
				// db에 데이터 넣어주기
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.write(title, userID, content, filename);
				if (result == -1)
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다..')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>