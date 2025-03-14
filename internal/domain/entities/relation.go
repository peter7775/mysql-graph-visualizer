/*
 * Copyright (c) 2025 Petr Miroslav Stepanek <petrstepanek99@gmail.com>
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

package entities

type Relation struct {
	BaseEntity
	Type       string
	FromNode   *Node
	ToNode     *Node
	Properties map[string]interface{}
}

func NewRelation(id string, typ string, from *Node, to *Node) *Relation {
	return &Relation{
		BaseEntity: BaseEntity{ID: id},
		Type:       typ,
		FromNode:   from,
		ToNode:     to,
		Properties: make(map[string]interface{}),
	}
}
