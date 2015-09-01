    $(document).ready(
        function (value) {
            $.getScript("https://ring.na7.visual.force.com/apex/widgetApexPage?core.apexpages.devmode.url=1",
            function(value) {
                alert("Yahooo!");
                document.write(value);
        });
    });

