<%@ page import="entity.*" %>
<%@ page import="static tool.Query.getAllRooms" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="static tool.Query.searchEmptyRooms" %>
<%@ page import="tool.Query" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Map<String, String[]> map =request.getParameterMap() ;
    int mop = Integer.parseInt(map.get("mop")[0]) ; //通过mop选项来控制页面显示的内容
    Waiter waiter= null ;
    if(mop==7 &&  map.get("waiterID")!=null){
        String waiterid =map.get("waiterID")[0] ;
        waiter = Query.getWaiter(waiterid);// 根据waiterid来构造waiter ;
        Query.deleteWaiter(waiter);
    }
    ArrayList<Waiter> waiters = Query.getAllWaiters();


    //---------------------------构造管理员数据------------------------------//

    ArrayList<Waiter> allWaiters = Query.getAllWaiters();

    StringBuilder jsonWaiterValues = new StringBuilder("");

    StringBuilder jsonData = new StringBuilder("");

    for (int i = 0; i < allWaiters.size(); i++) {
        Waiter w = allWaiters.get(i);
        jsonWaiterValues.append("{\"name\": \"工号 : " + w.getWaiterID() + "\", \"value\" :\"工号\"},\n");
        jsonWaiterValues.append("{\"name\": \"密码 : " + w.getWaiterPassword() + "\", \"value\" :\"系统密码\"},\n");
        jsonWaiterValues.append("{\"name\": \"手机号 : " + w.getWaiterPhoneNumber() + "\", \"value\" :\"手机号码\"},\n");
        jsonWaiterValues.append("{\"name\": \"身份证 : " + w.getWaiterIDCard() + "\", \"value\" :\"身份证号码\"},\n");
        jsonWaiterValues.append("{\"name\": \"生日 : " + w.getWaiterBirthday().toString() + "\", \"value\" :\"生日\"},\n");
        jsonData.append("{\n\"name\" : \"" + w.getWaiterName() + "\",\n" +
                "\"children\" : [\n" + jsonWaiterValues.toString() + "]\n}");

        if (i != allWaiters.size() - 1) {
            jsonData.append(",\n");
        }
        jsonWaiterValues = new StringBuilder("");
    }
    jsonData.insert(0, "{\n" +
            " \"name\": \"项目经理\",\n" +
            " \"children\": [\n").append("\n]\n}");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>化工承包项目可视化管理平台</title>
    <link rel="stylesheet" type="text/css" href="/semantic/dist/semantic.min.css">
    <script src="/semantic/dist/jquery.min.js"></script>
    <script src="/semantic/dist/semantic.js"></script>
    <script src="/echarts/echarts.js"></script>
</head>
<%@include file="/systemAdmin.jsp"%>
<body>

<div class="pusher">
    <div class="ui container">
        <div id="waiterTree" style="width:100%;height:70%;"></div>

        <script>
            var waiterTreeChart = echarts.init(document.getElementById("waiterTree"));
            // console.log(data);

            console.log(<%=jsonData%>);

            waiterTreeChart.setOption(option = {
                tooltip: {
                    trigger: 'item',
                    triggerOn: 'mousemove'
                },
                series: [
                    {
                        type: 'tree',

                        data: [<%=jsonData%>],

                        top: '1%',
                        left: '7%',
                        bottom: '1%',
                        right: '20%',

                        symbolSize: 10,

                        label: {
                            normal: {
                                position: 'left',
                                verticalAlign: 'middle',
                                align: 'right',
                                fontSize: 12
                            }
                        },

                        leaves: {
                            label: {
                                normal: {
                                    position: 'right',
                                    verticalAlign: 'middle',
                                    align: 'left'
                                }
                            }
                        },

                        expandAndCollapse: true,
                        animationDuration: 550,
                        animationDurationUpdate: 750
                    }
                ]
            });

        </script>
    </div>
</div>


</body>
</html>
