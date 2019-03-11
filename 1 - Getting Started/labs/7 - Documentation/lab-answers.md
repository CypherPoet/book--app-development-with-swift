## Step 2: Use Documentation to Learn About the UIView Class

#### What are three of the primary responsibilities of a UIView object?
1. Drawing and Animation
2. Layout and subview management
3. Event Handling


#### What does documentation call a view that's embedded in another view?
A subview

#### What does documentation call the parent view that's embedding the other view?
The superview

#### What is a view's frame?
 The frame property defines the origin and dimensions of the view in the coordinate system of its superview

#### How is a view's bounds different from its frame?
A frame is defined in terms of its containing context, whereas the `bounds` property defines the internal dimensions of the view. This means it knows nothing about the outside context.

When we're drawing things inside of a frame, we can use coordinates and measurements that are relative to the `bounds`.
