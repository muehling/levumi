<template>
    <div>
      <div 
      class = "sidebarElement view1" 
      :class="{strong: view1, current: exactView1}">
        Fragetyp
      </div>

      <div 
      class = "sidebarElement view2" 
      :class="{strong: view2, current: exactView2}">
        Eigenschaften
      </div>

      <div 
      class = "sidebarElement view3" 
      :class="{strong: view3, current: exactView3}">
        Dateiupload
      </div>

      <div 
      class = "sidebarElement view4" 
      :class="{strong: view4, current: exactView4}">
        Abschluss und Herunterladen
      </div>

    </div>
  </template>
    
  <script>
    export default {
      props: ["view"],

      data () {
        return {
        }
      },
  
      methods: {
        log: function(){
            console.log(this.view)
        }
        
      },

      computed: {
        view1(){
            return this.view > 0;
        },

        view2(){
            return this.view > 1;
        },

        view3(){
            return this.view > 2;
        },

        view4(){
            return this.view > 3;
        },

        exactView1(){
            return this.view == 1;
        },

        exactView2(){
            return this.view == 2;
        },

        exactView3(){
            return this.view == 3;
        },

        exactView4(){
            return this.view == 4;
        },
      }
    }
  </script>
    
  <style>

  .sidebarElement{
    font-size: 0.9rem;
    color: grey;
    position: absolute;
    left: 2%;
  }

  .view1{
    top: 10%;
  }

  .view2{
    top: 13%;
  }

  .view3{
    top: 16%;
  }

  .view4{
    top: 19%;
  }

  .strong{
    font-size: 1.1rem;
    color: black;
    transition-duration: 0.5s;
  }

  .current{
    font-size: 1.4rem;
    line-height: 1.4rem;
    transition-duration: 0.5s;
  }
  
  </style>