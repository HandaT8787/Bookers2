import Raty from "raty-js"

document.addEventListener("turbo:load", () => {
  const postElem = document.querySelector("#post_raty");
  if (postElem) {
    new Raty(postElem, {
      scoreName: "book[score]",
      starOn: postElem.dataset.starOn,
      starOff: postElem.dataset.starOff,
      starHalf: postElem.dataset.starHalf
    }).init();
  }

  const showElems = document.querySelectorAll(".show_raty");
  showElems.forEach((elem) => {
    new Raty(elem, {
      readOnly: true,
      score: elem.dataset.score,
      starOn: elem.dataset.starOn,
      starOff: elem.dataset.starOff,
      starHalf: elem.dataset.starHalf
    }).init();
  });
});