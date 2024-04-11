---
title: ""
format: html
server: shiny
---

## Shiny Documents

This Quarto document is made interactive using Shiny. Interactive documents allow readers to modify parameters and see the results immediately. Learn more about Shiny interactive documents at <https://quarto.org/docs/interactive/shiny/>.

## Inputs and Outputs

You can embed Shiny inputs and outputs in your document. Outputs are automatically updated whenever inputs change. This demonstrates how a standard R plot can be made interactive:


```r
sliderInput("bins", "Number of bins:", 
            min = 1, max = 50, value = 30)
```

<!--html_preserve--><div class="form-group shiny-input-container">
<label class="control-label" id="bins-label" for="bins">Number of bins:</label>
<input class="js-range-slider" id="bins" data-skin="shiny" data-min="1" data-max="50" data-from="30" data-step="1" data-grid="true" data-grid-num="9.8" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
</div><!--/html_preserve-->

```r
plotOutput("distPlot")
```

<!--html_preserve--><div class="shiny-plot-output html-fill-item" id="distPlot" style="width:100%;height:400px;"></div><!--/html_preserve-->


```r
output$distPlot <- renderPlot({
   x <- faithful[, 2]  # Old Faithful Geyser data
   bins <- seq(min(x), max(x), length.out = input$bins + 1)
   hist(x, breaks = bins, col = 'darkgray', border = 'white',
        xlab = 'Waiting time to next eruption (in mins)',
        main = 'Histogram of waiting times')
})
```

```
## Error: object 'output' not found
```
