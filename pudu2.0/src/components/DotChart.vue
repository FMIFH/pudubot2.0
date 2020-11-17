<script>
    import { Line, mixins } from "vue-chartjs";
    const { reactiveProp } = mixins

    export default {
      extends: Line,
      mixins: [reactiveProp],
      props: {
        label: {
          type: String
        },
        chartData: {
          type: Array
        },
        options: {
          type: Object
        },
        chartColors: {
          type: Object
        },
        chartLabels:{
            type: Array
        }
      },
      mounted() {
        const totals = this.chartData.map(d => d.total);

        const {
          borderColor,
          pointBorderColor,
          pointBackgroundColor,
          backgroundColor,
          type,
          barThickness
        } = this.chartColors;
    
        this.renderChart(
          {
            labels: this.chartLabels,
            datasets: [
              {
                label: this.label,
                data: totals,
                borderColor: borderColor,
                pointBorderColor: pointBorderColor,
                pointBackgroundColor: pointBackgroundColor,
                backgroundColor: backgroundColor,
                type : type,
                barThickness : barThickness
              }
            ]
          },
          this.options
        );
      }
    };
</script>