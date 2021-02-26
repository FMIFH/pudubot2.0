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
      chartDataLabels: {
        type: Array
      },
      options: {
        type: Object
      },
      chartColors: {
        type: Object
      }
    },

    data() {
      return {
        gradient2: null
      }
    },

    mounted() {
      const dates = this.chartDataLabels;
      const totals = this.chartData;

      this.gradient2 = this.$refs.canvas
        .getContext("2d")
        .createLinearGradient(0, 0, 0, 450);

      this.gradient2.addColorStop(0, "rgba(38, 78, 223, 0.9)");
      this.gradient2.addColorStop(0.5, "rgba(38, 78, 223, 0.25)");
      this.gradient2.addColorStop(1, "rgba(38, 78, 223, 0)");

      this.renderChart(
        {
          labels: dates,
          datasets: [
            {
              label: this.label,
              data: totals,
              borderColor: "#264edfc7",
              pointBackgroundColor: "white",
              pointBorderColor: "white",
              borderWidth: 1,
              backgroundColor: this.gradient2,
            }
          ]
        },
        this.options
      );
    }
  };
</script>

<style>

</style>