var ctx = document.getElementsById("myChart").getContext('2d');
var Graph = new CharacterData(ctx, {
  type: 'line',
  data: {
    labels: ['月', '火', '水', '木', '金', '土', '日'],
    datasets: [
      {
        label: 'ゴミの量',
        data: [2, 4, 5, 3, 4, 7, 5],
        borderColor: 'rgba(255,0,0,1)',
        backgroundColor: 'rgba(0,0,0,0)'
      }
    ],
  },
  option: {
    title: {
      display: true,
      text: 'ゴミ(８月３周)'
    },
    scales: {
      yAxes: [{
        ticks: {
          suggestedMax: 10,
          suggestedMin: 0,
          stepSize: 2,
          callback: function(value, index, values) {
            return value + 'kg'
          }
        }
      }]
    },
  }
});