import React from "react";

import "./Card.css";

function Card(props) {
  return (
    <div className="card">
      <h1>My Goals</h1>
      {props.children}
    </div>
  );
}

export default Card;
